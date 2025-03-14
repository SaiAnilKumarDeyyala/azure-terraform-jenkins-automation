resource_group_name = "jenkins-rg"
location            = "eastus"
tags = {
  "created_by" = "terraform"
}

## V-NET ###
vnet_name               = "jenkins-vnet"
address_space           = ["10.0.0.0/16"]
subnet_name             = "jenkins-subnet"
subnet_address_prefixes = ["10.0.1.0/24"]
nsg_name                = "jenkins-nsg"
nic_name                = "jenkins-nic"
ip_configuration_name   = "jenkins-ip-config"
vm_name                 = "jenkins-vm"
vm_size                 = "Standard_B1s"
os_disk_name            = "jenkins-os-disk"
vm_username             = "jenkinsadmin"
vm_password             = "P@ssw0rd@123"
