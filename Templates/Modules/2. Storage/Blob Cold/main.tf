provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     									= "${var.prefix}-RG1"
  location 									= var.location
}

module "storage" {
  source 									= "innovationnorway/storage/azurerm"
  name 										= "${var.prefix}storage1"
  resource_group_name 						= azurerm_resource_group.rg.name
  access_tier								= "Cold"
  kind 										= "StorageV2"
  sku 										= "Standard_LRS"

  containers = [
    {
      name  = "data"
      access_type = "private"
    }
  ]

  tags = {
    environment 							= "IT"
    application 							= "Storage"
  }   
}