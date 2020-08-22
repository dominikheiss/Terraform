provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg_main" {
  name = "rg_main"
  location = "west europe"
}

# Create the  VNET
resource "azurerm_virtual_network" "vnet_main" {
  name = "vnet_main"
  address_space = ["10.100.0.0/16"]
  resource_group_name = azurerm_resource_group.rg_main.name
  location = azurerm_resource_group.rg_main.location
}

# Create a subnet for Azure Servers
resource "azurerm_subnet" "Server" {
  name = "Server" 
  address_prefixes = ["10.100.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  resource_group_name = azurerm_resource_group.rg_main.name
}

# Create a subnet for Windows Virtual Desktops
resource "azurerm_subnet" "WVD" {
  name = "WVD" 
  address_prefixes = ["10.100.10.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  resource_group_name = azurerm_resource_group.rg_main.name
}

# Create a subnet for Azure Bastion Host
resource "azurerm_subnet" "AzureBastionSubnet" {
  name = "AzureBastionSubnet" 
  address_prefixes = ["10.100.254.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  resource_group_name = azurerm_resource_group.rg_main.name
}

# Create a subnet for VPN Gateway
resource "azurerm_subnet" "Gateway" {
  name = "Gateway" 
  address_prefixes = ["10.100.255.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  resource_group_name = azurerm_resource_group.rg_main.name
}