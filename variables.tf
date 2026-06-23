variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
  default     = "francecentral"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  sensitive   = true
}

variable "vm_name" {
  type        = string
  default     = "prestashop-vm"
}

variable "public_ip_name" {
  type        = string
  default     = "prestashop-pip"
}

variable "vnet_name" {
  type        = string
  default     = "prestashop-vnet"
}

variable "subnet_name" {
  type        = string
  default     = "prestashop-subnet"
}

variable "nsg_name" {
  type        = string
  default     = "prestashop-nsg"
}

variable "nic_name" {
  type        = string
  default     = "prestashop-nic"
}