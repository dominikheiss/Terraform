provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_main" {
  name     = "my-resources"
  location = "West Europe"
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg_main.name
  address_space       = ["10.100.0.0/16"]
  subnet_prefixes     = ["10.100.1.0/24", "10.100.10.0/24", "10.100.254.0/24", "10.100.255.0/24"]
  subnet_names        = ["Server", "WVD", "BastionHost", "Gateway"]

  tags = {
    environment = "dev"
    costcenter  = "dhe"
  }
}