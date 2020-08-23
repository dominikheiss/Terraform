# Bechtle-Terraform for Azure/o365

==> Azure Cloud Shell

1. git clone https://github.com/dominikheiss/Bechtle-Terraform.git

2. cd Bechtle-Terraform/Templates/xxx

3. terraform init

4. terraform apply










# Mindmap

### To import existing ressources:

terraform import azurerm_resource_group.rg /subscriptions/7e6721ba-af2a-43d0-a91c-44a181da888c/resourceGroups/rg_main



### To Remove a directory in Azure Cloud Shell && reclone the GIT Repo:

cd ~ && rm -R -f  terraform-azure && git clone https://github.com/dominikheiss/Bechtle-Terraform.git



### To rejoin the last directory & init & apply

cd Bechtle-Terraform/Templates/xxx && terraform init && terraform apply



### To get Azure Marketplace Images Details

az vm image list --output table --all --publisher Veeam
