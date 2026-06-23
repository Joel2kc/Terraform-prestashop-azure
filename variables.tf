variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "francecentral"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "prestashop-vm"
}

variable "public_ip_name" {
  description = "Name of the public IP resource"
  type        = string
  default     = "prestashop-pip"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "prestashop-vnet"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "prestashop-subnet"
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "prestashop-nsg"
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "prestashop-nic"
}