# --------------------------------------------------
# Azure Resource Group Configuration (main.tf)
# --------------------------------------------------

variable "environment" {
  type        = string
  description = "Deployment environment name."
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
  default     = "germanywestcentral"
}

# --------------------------------------------------
# Azure Virtual Network Configuration (network.tf)
# --------------------------------------------------


variable "vnet_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space of the Azure Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the Azure subnet"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix of the Azure subnet"
  type        = string
}


# --------------------------------------------------
# Azure Virtual Machine Configuration (vm.tf)
# --------------------------------------------------

variable "vm_name" {
  description = "Name of the Azure Virtual Machine"
  type        = string
}

variable "vm_size" {
  description = "Azure Virtual Machine size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username for the Linux VM"
  type        = string
  default     = "azureadmin"
}

variable "authentication_type" {
  description = "Authentication method: ssh or password"
  type        = string
  default     = "ssh"

  validation {
    condition     = contains(["ssh", "password"], var.authentication_type)
    error_message = "Authentication type must be ssh or password."
  }
}

variable "admin_password" {
  description = "Administrator password when password authentication is enabled"
  type        = string
  sensitive   = true
  default     = null
}


# --------------------------------------------------
# External Drift Detection Scheduler (drift-scheduler.tf)
# --------------------------------------------------

variable "enable_drift_scheduler" {
  description = "Deploy the Logic App that triggers the drift detection workflow on a timer"
  type        = bool
  default     = false
}

variable "drift_scheduler_key_vault_name" {
  description = "Globally unique name of the Key Vault storing the GitHub token (3-24 characters)"
  type        = string
  default     = null
}

variable "drift_scheduler_secret_admin_object_id" {
  description = "Entra ID object ID of the user or group allowed to store and rotate the GitHub token"
  type        = string
  default     = null
}

variable "github_repository" {
  description = "GitHub repository in the format owner/repo"
  type        = string
  default     = "matrix1302/terraform-azure-backend-demo"
}

variable "drift_workflow_file" {
  description = "File name of the drift detection workflow in .github/workflows"
  type        = string
  default     = "terraform-drift-detection.yml"
}

variable "drift_workflow_ref" {
  description = "Branch the drift detection workflow is dispatched on"
  type        = string
  default     = "main"
}

variable "drift_schedule_time_zone" {
  description = "Windows time zone ID used by the Logic App recurrence trigger"
  type        = string
  default     = "W. Europe Standard Time"
}

variable "drift_schedule_hour" {
  description = "Hour (local time) at which the drift check is triggered"
  type        = number
  default     = 7
}

variable "drift_schedule_minute" {
  description = "Minute at which the drift check is triggered"
  type        = number
  default     = 23
}