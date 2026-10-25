environment         = "prod"
resource_group_name = "rg-terraform-backend-prod"
location            = "germanywestcentral"

# Azure Virtual Network and Subnet
vnet_name             = "vnet-terraform-prod"
vnet_address_space    = "10.30.0.0/16"
subnet_name           = "snet-workload"
subnet_address_prefix = "10.30.1.0/24"