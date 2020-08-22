terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>1.31"
    }
  }
}

# Configure the Microsoft Azure Provider.
provider "azurerm" {}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-general-dhe"
  location = "West Europe"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet_main"
  address_space       = ["10.100.0.0/16"]
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "Server"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.1.0/24"]
}

# Create subnet
resource "azurerm_subnet" "subnet2" {
  name                 = "WVD"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.10.0/24"]
}