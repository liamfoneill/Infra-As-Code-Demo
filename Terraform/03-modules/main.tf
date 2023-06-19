# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatefdbdfb"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "${env.ARM_SUBSCRIPTION_ID}"
  client_id       = "${env.ARM_CLIENT_ID}"
  client_secret   = "${env.ARM_CLIENT_SECRET}"
  tenant_id       = "${env.ARM_TENANT_ID}"
}

module "health_storage_module" {
    source = ".\\modules\\storage"

    prefix = "liamdemo"
}