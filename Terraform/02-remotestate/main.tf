terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
      backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfstatefdbdfb"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
  required_version = ">= 1.1.0"

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "uksouth"
}

resource "azurerm_storage_account" "stg" {
  name                = "tdstgsdg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}