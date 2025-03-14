data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source                  = "./modules/vnet"
  vnet_name               = var.vnet_name
  location                = data.azurerm_resource_group.rg.location
  resource_group_name     = data.azurerm_resource_group.rg.name
  address_space           = var.address_space
  subnet_name             = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  nsg_name                = var.nsg_name
  tags                    = var.tags
}

module "vm" {
  source                = "./modules/vm"
  vm_name               = var.vm_name
  nic_name              = var.nic_name
  ip_configuration_name = var.ip_configuration_name
  subnet_id             = module.vnet.subnet_id
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  vm_size               = var.vm_size
  vm_username           = var.vm_username
  vm_password           = var.vm_password
  tags                  = var.tags
  os_disk_name          = var.os_disk_name
}