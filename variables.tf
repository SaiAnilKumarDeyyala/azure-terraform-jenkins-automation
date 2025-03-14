## COMMON ##
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the resource group"
  type        = string
}

## VNET ##
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space of the virtual network"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefixes of the subnet"
  type        = list(string)
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
}


## FOR VM ##
variable "nic_name" {
  description = "Name of the network interface"
  type        = string
}

variable "ip_configuration_name" {
  description = "Name of the IP configuration"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "os_disk_name" {
  description = "Name of the OS disk"
  type        = string
}

variable "vm_username" {
  description = "Username of the virtual machine"
  type        = string
}

variable "vm_password" {
  description = "Password of the virtual machine"
  type        = string
}

variable "tags" {
  description = "Tags of the virtual machine"
  type        = map(string)
}


