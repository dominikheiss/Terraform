provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-var.prefix"
  location = "var.location"
}

# Create the  VNET
resource "azurerm_virtual_network" "vnet" {
  name = "vnet-var.prefix"
  address_space = ["10.100.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}

# Create a subnet for Azure Servers
resource "azurerm_subnet" "Server" {
  name = "Server" 
  address_prefixes = ["10.100.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet for Windows Virtual Desktops
resource "azurerm_subnet" "WVD" {
  name = "WVD" 
  address_prefixes = ["10.100.10.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet for Azure Bastion Host
resource "azurerm_subnet" "AzureBastionSubnet" {
  name = "AzureBastionSubnet" 
  address_prefixes = ["10.100.254.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet for VPN Gateway
resource "azurerm_subnet" "Gateway" {
  name = "Gateway" 
  address_prefixes = ["10.100.255.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
}