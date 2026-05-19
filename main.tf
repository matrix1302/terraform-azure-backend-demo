terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "sttfbackenddemo2026"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "rg_demo_tf_backend" {
  name     = "rg-terraform-backend-demo"
  location = "germanywestcentral"

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}