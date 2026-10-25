
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg_demo_tf_backend.location
  resource_group_name = azurerm_resource_group.rg_demo_tf_backend.name

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "terraform-github-demo"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg_demo_tf_backend.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}
