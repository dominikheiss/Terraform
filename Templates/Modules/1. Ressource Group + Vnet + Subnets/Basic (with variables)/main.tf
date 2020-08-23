provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     									= "${var.prefix}-RG1"
  location 									= var.location
}

module "network" {
  source              						= "Azure/network/azurerm"
  resource_group_name 						= azurerm_resource_group.rg.name
  vnet_name									= "${var.prefix}-VNET1"
  address_space       						= "10.100.0.0/16"
  subnet_prefixes     						= ["10.100.1.0/24", "10.100.10.0/24", "10.100.254.0/24", "10.100.255.0/24"]
  subnet_names        						= ["Server", "WVD", "AzureBastionSubnet", "Gateway"]

  tags = {
    environment 							= "IT"
    application 							= "Network"
  } 
}