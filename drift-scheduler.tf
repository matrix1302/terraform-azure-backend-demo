# --------------------------------------------------
# External Drift Detection Scheduler (Azure Logic App)
# --------------------------------------------------
# GitHub's native "schedule" trigger is best-effort: runs can be delayed or
# dropped entirely under load. This Logic App triggers the drift detection
# workflow on a fixed timer through the GitHub REST API (workflow_dispatch).
#
# Deployed only where enable_drift_scheduler = true (prod).
#
# The GitHub token is NOT managed by Terraform (it would end up in the state).
# Store it manually after the first apply:
#
#   az keyvault secret set --vault-name <key vault name> \
#     --name github-drift-dispatch-token --value <fine-grained PAT>
# --------------------------------------------------

data "azurerm_client_config" "current" {}

locals {
  drift_scheduler_count = var.enable_drift_scheduler ? 1 : 0

  github_dispatch_uri = "https://api.github.com/repos/${var.github_repository}/actions/workflows/${var.drift_workflow_file}/dispatches"
}

# --------------------------------------------------
# Key Vault holding the GitHub token
# --------------------------------------------------
# Access policies instead of Azure RBAC: the deployment service principal
# only has Contributor and therefore cannot create role assignments.

resource "azurerm_key_vault" "drift_scheduler" {
  count = local.drift_scheduler_count

  name                       = var.drift_scheduler_key_vault_name
  location                   = azurerm_resource_group.rg_demo_tf_backend.location
  resource_group_name        = azurerm_resource_group.rg_demo_tf_backend.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = false
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "terraform-github-demo"
  }
}

# Lets the administrator store and rotate the GitHub token.
resource "azurerm_key_vault_access_policy" "drift_scheduler_admin" {
  count = local.drift_scheduler_count

  key_vault_id = azurerm_key_vault.drift_scheduler[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.drift_scheduler_secret_admin_object_id

  secret_permissions = ["Get", "List", "Set", "Delete", "Recover"]
}

# Lets the Logic App's managed identity read the GitHub token (read-only).
resource "azurerm_key_vault_access_policy" "drift_scheduler_logic_app" {
  count = local.drift_scheduler_count

  key_vault_id = azurerm_key_vault.drift_scheduler[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_logic_app_workflow.drift_scheduler[0].identity[0].principal_id

  secret_permissions = ["Get"]
}

# --------------------------------------------------
# Logic App Workflow
# --------------------------------------------------

resource "azurerm_logic_app_workflow" "drift_scheduler" {
  count = local.drift_scheduler_count

  name                = "logic-terraform-drift-${var.environment}"
  location            = azurerm_resource_group.rg_demo_tf_backend.location
  resource_group_name = azurerm_resource_group.rg_demo_tf_backend.name

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "terraform-github-demo"
  }
}

# Daily timer in local time. Unlike GitHub cron (always UTC), the Logic App
# handles daylight saving time automatically.
resource "azurerm_logic_app_trigger_recurrence" "drift_scheduler" {
  count = local.drift_scheduler_count

  name         = "Daily_Drift_Check"
  logic_app_id = azurerm_logic_app_workflow.drift_scheduler[0].id
  frequency    = "Day"
  interval     = 1
  time_zone    = var.drift_schedule_time_zone

  schedule {
    at_these_hours   = [var.drift_schedule_hour]
    at_these_minutes = [var.drift_schedule_minute]
  }
}

# Step 1: Read the GitHub token from Key Vault using the managed identity.
resource "azurerm_logic_app_action_custom" "get_github_token" {
  count = local.drift_scheduler_count

  name         = "Get_GitHub_Token"
  logic_app_id = azurerm_logic_app_workflow.drift_scheduler[0].id

  body = jsonencode({
    type = "Http"
    inputs = {
      method = "GET"
      uri    = "${azurerm_key_vault.drift_scheduler[0].vault_uri}secrets/github-drift-dispatch-token?api-version=7.4"
      authentication = {
        type     = "ManagedServiceIdentity"
        audience = "https://vault.azure.net"
      }
    }
    # Hide the token in the Logic App run history.
    runtimeConfiguration = {
      secureData = {
        properties = ["inputs", "outputs"]
      }
    }
    runAfter = {}
  })

  depends_on = [azurerm_key_vault_access_policy.drift_scheduler_logic_app]
}

# Step 2: Trigger the drift detection workflow via workflow_dispatch.
# GitHub answers with HTTP 204 (No Content) on success.
resource "azurerm_logic_app_action_custom" "dispatch_drift_workflow" {
  count = local.drift_scheduler_count

  name         = "Dispatch_Drift_Workflow"
  logic_app_id = azurerm_logic_app_workflow.drift_scheduler[0].id

  body = jsonencode({
    type = "Http"
    inputs = {
      method = "POST"
      uri    = local.github_dispatch_uri
      headers = {
        Accept                 = "application/vnd.github+json"
        Authorization          = "Bearer @{body('Get_GitHub_Token')?['value']}"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent"           = "azure-logic-app-terraform-drift"
      }
      body = {
        ref = var.drift_workflow_ref
      }
    }
    runtimeConfiguration = {
      secureData = {
        properties = ["inputs"]
      }
    }
    runAfter = {
      Get_GitHub_Token = ["Succeeded"]
    }
  })

  depends_on = [azurerm_logic_app_action_custom.get_github_token]
}