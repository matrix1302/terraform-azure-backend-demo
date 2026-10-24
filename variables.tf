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
