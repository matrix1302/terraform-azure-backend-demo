environment         = "test"
resource_group_name = "rg-terraform-backend-test"
location            = "germanywestcentral"

# Azure Virtual Network and Subnet
vnet_name             = "vnet-terraform-test"
vnet_address_space    = "10.20.0.0/16"
subnet_name           = "snet-workload"
subnet_address_prefix = "10.20.1.0/24"