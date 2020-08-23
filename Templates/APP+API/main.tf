provider "azurerm" {
  features {}
}

##### Create a resource group

#resource "azurerm_resource_group" "rg" {
#  name     					= "${var.prefix}-RG1"
#  location 					= var.location
#}

##### Use existing resource group 
#data "azurerm_resource_group" "gepgroup1" {
#    name     = "NexxeNeo4j-rg"
#}


##### Create Veeam APP for Modern Authentication

resource "azuread_application" "veeamapp" {
  name = "VeeamAPP"
  required_resource_access {
    # MicrosoftGraph API
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    # APPLICATION PERMISSIONS: "Read directory data":
    # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }
    # APPLICATION PERMISSIONS: "Read group data":
    # 5b567255-7703-4780-807c-7be8301ae99b
    resource_access {
      id   = "5b567255-7703-4780-807c-7be8301ae99b"
      type = "Role"
    }	
  }
}
#output "azure_ad_object_id" {
#  value = data.azuread_application.veeamapp.id
#}


