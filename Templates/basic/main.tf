provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_main" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet_main" {
  name                = "${var.prefix}-vnet_main"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  location            = "${azurerm_resource_group.rg_main.location}"
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "Servers" {
  name                 = "Servers"
  virtual_network_name = "${azurerm_virtual_network.rg_main.name}"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_subnet" "WVD" {
  name                 = "WVD"
  virtual_network_name = "${azurerm_virtual_network.rg_main.name}"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  address_prefixes     = ["10.100.10.0/24"]
}

resource "azurerm_subnet" "BastionHost" {
  name                 = "BastionHost"
  virtual_network_name = "${azurerm_virtual_network.rg_main.name}"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  address_prefixes     = ["10.100.254.0/24"]
}

resource "azurerm_subnet" "Gateway" {
  name                 = "Gateway"
  virtual_network_name = "${azurerm_virtual_network.rg_main.name}"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  address_prefixes     = ["10.100.255.0/24"]
}
