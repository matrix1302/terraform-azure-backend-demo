terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "rg_demo_tf_backend" {
  name     = "rg-terraform-backend-demo"
  location = "germanywestcentral"

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}