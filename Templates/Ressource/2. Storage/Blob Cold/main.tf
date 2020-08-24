provider "azurerm" {
  features {}
}

##### Create a resource group

resource "azurerm_resource_group" "rg" {
  name     					= "${var.prefix}-RG1"
  location 					= var.location
}

##### Create a Storage Account (Cold, LRS)

resource "azurerm_storage_account" "storage" {
  name                     	= "${var.prefix}storage1"
  resource_group_name      	= azurerm_resource_group.rg.name
  location                 	= azurerm_resource_group.rg.location
  account_kind				= "StorageV2"
  account_tier             	= "Standard"
  account_replication_type 	= "LRS"
  access_tier				= "Cool"
}

##### Create a Blob Container

resource "azurerm_storage_container" "container" {
  name                  	= "data"
  storage_account_name  	= azurerm_storage_account.storage.name
  container_access_type 	= "private"
}
