# --------------------------------------------------
# Azure Network Interface
# --------------------------------------------------

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg_demo_tf_backend.location
  resource_group_name = azurerm_resource_group.rg_demo_tf_backend.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "terraform-github-demo"
  }
}

# --------------------------------------------------
# Azure Linux Virtual Machine
# --------------------------------------------------

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg_demo_tf_backend.name
  location            = azurerm_resource_group.rg_demo_tf_backend.location
  size                = var.vm_size

  admin_username = var.admin_username

  # SSH key or password authentication
  disable_password_authentication = var.authentication_type == "ssh"
  admin_password                  = var.authentication_type == "password" ? var.admin_password : null

  dynamic "admin_ssh_key" {
    for_each = var.authentication_type == "ssh" ? [1] : []

    content {
      username   = var.admin_username
      public_key = file("${path.module}/keys/terraform_vm.pub")
    }
  }

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "terraform-github-demo"
  }
}