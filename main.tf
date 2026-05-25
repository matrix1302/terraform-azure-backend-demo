terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "rg_demo_tf_backend" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    project = "terraform-github-demo"
  }
}