# Bechtle-Terraform for Azure/o365

1. git clone https://github.com/dominikheiss/Bechtle-Terraform.git

2. cd Bechtle-Terraform/xxx

3. terraform init

4. terraform apply










# Mindmap

To import existing ressources:

terraform import azurerm_resource_group.rg_main /subscriptions/7e6721ba-af2a-43d0-a91c-44a181da888c/resourceGroups/rg_main

To Remove a directory in Azure Cloud Shell && reclone the GIT Repo:

rm -R -f  terraform-azure && git clone https://github.com/dominikheiss/terraform-azure.git

To rejoin the last directory & init & apply

cd terraform-azure/Templates/basic4 && terraform init && terraform apply

To get Azure Marketplace Images Details

az vm image list --output table --all --publisher Veeam


az ad app permission admin-consent --id $serverApplicationId
