provider "azurerm" {
  features {}
}

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

resource "random_string" "password" {
  length  = 33
  special = true
}

resource "azuread_application_password" "clientsecret" {
  application_object_id 	= azuread_application.veeamapp.id
  value          			= random_string.password.result
  description           	= "Veeam Secret"
  end_date       			= "2099-01-01T01:02:03Z"
}


output "azure_ad_object_id" {
  description = "API Key"
  value = azuread_application.veeamapp.id
}

output "client_secret" {
  description = "Client Secret"
  value       = random_string.password.result
}








/*
resource "null_resource" "delay_before_consent" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
}
resource "null_resource" "grant_srv_admin_constent" {
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${azuread_application.veeamapp.application_id}"
  }
  depends_on = [
    null_resource.delay_before_consent
  ]
}
*/

