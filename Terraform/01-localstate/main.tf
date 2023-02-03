terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "stgResourceGroup" {
  name     = "rg-terraform2"
  location = "uksouth"
}

resource "azurerm_storage_account" "stg" {
  name                     = "tdstgsddfsfg"
  resource_group_name      = azurerm_resource_group.stgResourceGroup.name
  location                 = azurerm_resource_group.stgResourceGroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}