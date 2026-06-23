terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "prestashop" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "prestashop" {
  name                = var.vnet_name
  location            = azurerm_resource_group.prestashop.location
  resource_group_name = azurerm_resource_group.prestashop.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "prestashop" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.prestashop.name
  virtual_network_name = azurerm_virtual_network.prestashop.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "prestashop" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.prestashop.location
  resource_group_name = azurerm_resource_group.prestashop.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "prestashop" {
  name                = var.nsg_name
  location            = azurerm_resource_group.prestashop.location
  resource_group_name = azurerm_resource_group.prestashop.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "prestashop" {
  name                = var.nic_name
  location            = azurerm_resource_group.prestashop.location
  resource_group_name = azurerm_resource_group.prestashop.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.prestashop.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.prestashop.id
  }
}

resource "azurerm_network_interface_security_group_association" "prestashop" {
  network_interface_id      = azurerm_network_interface.prestashop.id
  network_security_group_id = azurerm_network_security_group.prestashop.id
}

resource "azurerm_linux_virtual_machine" "prestashop" {
  name                            = var.vm_name
  location                        = azurerm_resource_group.prestashop.location
  resource_group_name             = azurerm_resource_group.prestashop.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.prestashop.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

output "vm_public_ip" {
  description = "The public IP address of the PrestaShop VM"
  value       = azurerm_public_ip.prestashop.ip_address
}