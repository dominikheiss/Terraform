provider "azurerm" {
  features {}
}

terraform import azurerm_resource_group.rg_main /subscriptions/7e6721ba-af2a-43d0-a91c-44a181da888c/resourceGroups/rg_main

# Create a resource group for core
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

# Create a subnet for Azure Bastion
resource "azurerm_subnet" "AzureBastionSubnet" {
  name = "AzureBastionSubnet" 
  address_prefixes = ["10.100.254.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  resource_group_name = azurerm_resource_group.rg_main.name
}

# Create a subnet for Site 2 Site VPN
resource "azurerm_subnet" "Gateway" {
  name = "Gateway" 
  address_prefixes = ["10.100.255.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  resource_group_name = azurerm_resource_group.rg_main.name
}