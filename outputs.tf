output "drift_scheduler_key_vault_name" {
  description = "Key Vault storing the GitHub token for the drift scheduler"
  value       = var.enable_drift_scheduler ? azurerm_key_vault.drift_scheduler[0].name : null
}

output "drift_scheduler_logic_app_name" {
  description = "Logic App triggering the drift detection workflow"
  value       = var.enable_drift_scheduler ? azurerm_logic_app_workflow.drift_scheduler[0].name : null
}