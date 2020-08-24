provider "azurerm" {
  features {}
}

##### Create a resource group

resource "azurerm_resource_group" "rg" {
<<<<<<< HEAD
  name     				      = "${var.prefix}-RG1"
  location 				      = var.location
=======
  name     				            = "${var.prefix}-RG1"
  location 			            	= var.location
>>>>>>> 287a42d23175996ca30c368136e6c6f52fe5ae6d
}

##### Create the VNET

resource "azurerm_virtual_network" "vnet" {
<<<<<<< HEAD
  name                	= "${var.prefix}-VNET"
  address_space 		    = ["10.100.0.0/16"]
  resource_group_name 	= azurerm_resource_group.rg.name
  location 				      = azurerm_resource_group.rg.location
=======
  name                      	= "${var.prefix}-VNET"
  address_space 		          = ["10.100.0.0/16"]
  resource_group_name 	      = azurerm_resource_group.rg.name
  location 				            = azurerm_resource_group.rg.location
>>>>>>> 287a42d23175996ca30c368136e6c6f52fe5ae6d
}

##### Create a subnet for Azure Servers

resource "azurerm_subnet" "Server" {
<<<<<<< HEAD
  name 					        = "Server" 
  address_prefixes 		  = ["10.100.1.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
=======
  name 					              = "Server" 
  address_prefixes 		        = ["10.100.1.0/24"]
  virtual_network_name 	      = azurerm_virtual_network.vnet.name
  resource_group_name 	      = azurerm_resource_group.rg.name
>>>>>>> 287a42d23175996ca30c368136e6c6f52fe5ae6d
}

##### Create a subnet for Windows Virtual Desktops

resource "azurerm_subnet" "WVD" {
<<<<<<< HEAD
  name 					        = "WVD" 
  address_prefixes 		  = ["10.100.10.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
=======
  name 					              = "WVD" 
  address_prefixes 		        = ["10.100.10.0/24"]
  virtual_network_name 	      = azurerm_virtual_network.vnet.name
  resource_group_name 	      = azurerm_resource_group.rg.name
>>>>>>> 287a42d23175996ca30c368136e6c6f52fe5ae6d
}

##### Create a subnet for Azure Bastion Host

resource "azurerm_subnet" "AzureBastionSubnet" {
<<<<<<< HEAD
  name 					        = "AzureBastionSubnet" 
  address_prefixes 		  = ["10.100.254.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
=======
  name 					              = "AzureBastionSubnet" 
  address_prefixes 		        = ["10.100.254.0/24"]
  virtual_network_name 	      = azurerm_virtual_network.vnet.name
  resource_group_name 	      = azurerm_resource_group.rg.name
>>>>>>> 287a42d23175996ca30c368136e6c6f52fe5ae6d
}

##### Create a subnet for VPN Gateway

resource "azurerm_subnet" "Gateway" {
<<<<<<< HEAD
  name 					        = "Gateway" 
  address_prefixes 		  = ["10.100.255.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
=======
  name 					              = "Gateway" 
  address_prefixes 		        = ["10.100.255.0/24"]
  virtual_network_name 	      = azurerm_virtual_network.vnet.name
  resource_group_name 	      = azurerm_resource_group.rg.name
>>>>>>> 287a42d23175996ca30c368136e6c6f52fe5ae6d
}