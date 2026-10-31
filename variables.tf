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