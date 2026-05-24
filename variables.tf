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