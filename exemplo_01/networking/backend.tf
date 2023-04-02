# ACCOUNT_KEY=$(az storage account keys list --resource-group sof-terraform --account-name tfstate31022 --query '[0].value' -o tsv)
# export ARM_ACCESS_KEY=$ACCOUNT_KEY

terraform {
  backend "azurerm" {
      resource_group_name  = "sof-terraform"
      storage_account_name = "tfstate31022"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}
