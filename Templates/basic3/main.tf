# Create a resource group for core
resource "azurerm_resource_group" "main-rg" {
  name = "main-rg"
  location = "west europe"
}

# Create the core VNET
resource "azurerm_virtual_network" "main-vnet" {
  name = "main-vnet"
  address_space = "10.100.0.0/16"
  resource_group_name = azurerm_resource_group.main-rg.name
  location = azurerm_resource_group.main-rg.location
}

# Create a subnet for Azure Firewall
resource "azurerm_subnet" "Server" {
  name = "Server" # mandatory name -do not rename-
  address_prefixes = "10.100.1.0/24"
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  resource_group_name = azurerm_resource_group.main-rg.name
}

# Create a subnet for Azure Firewall
resource "azurerm_subnet" "WVD" {
  name = "WVD" # mandatory name -do not rename-
  address_prefixes = "10.100.10.0/24"
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  resource_group_name = azurerm_resource_group.main-rg.name
}