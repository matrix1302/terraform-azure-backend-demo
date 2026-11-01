environment         = "prod"
resource_group_name = "rg-terraform-backend-prod"
location            = "germanywestcentral"

# Azure Virtual Network and Subnet
vnet_name             = "vnet-terraform-prod"
vnet_address_space    = "10.30.0.0/16"
subnet_name           = "snet-workload"
subnet_address_prefix = "10.30.1.0/24"


# Azure Virtual Machine
vm_name             = "vm-terraform-prod"
vm_size             = "Standard_B2s"
authentication_type = "ssh"

# External Drift Detection Scheduler (Azure Logic App)
enable_drift_scheduler                 = true
drift_scheduler_key_vault_name         = "kv-tf-drift-prod-2026"
drift_scheduler_secret_admin_object_id = "dd097024-a4d2-46a3-b5bf-b980aefd4b54"