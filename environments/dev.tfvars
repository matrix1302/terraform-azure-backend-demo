environment         = "dev"
resource_group_name = "rg-terraform-backend-dev"
location            = "germanywestcentral"


# Azure Virtual Network and Subnet
vnet_name             = "vnet-terraform-dev"
vnet_address_space    = "10.10.0.0/16"
subnet_name           = "snet-workload"
subnet_address_prefix = "10.10.1.0/24"
