provider "azurerm" {
  features {}
  alias = "spoke"
  subscription_id = var.subscription_id
}

provider "azurerm" {
  features {}
  alias = "hub"
  subscription_id = var.hub_subscription_id
}
