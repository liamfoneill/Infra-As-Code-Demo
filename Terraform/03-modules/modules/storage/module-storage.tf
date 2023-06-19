# Create an Azure Storage Account inside a VNET. 
# This storage account has the company defaults hardcoded for security and compliance

variable "prefix" {
  type        = string
  description = "Prefix for the your Azure Resources. This can be 8 character long max and must be all lowercase"

  validation {
    condition     = length(var.prefix) <= 8
    error_message = "The prefix must be 8 characters long max"
  }
}

variable "azure_region" {
  type        = string
  description = "Azure Region to deploy the resources. This can either be UK South or UK West"
  default     = "uksouth"

  validation {
    condition     = var.azure_region == "uksouth" || var.azure_region == "ukwest"
    error_message = "The Azure Region must be either UK South or UK West"
  }
}

variable "account_replication_type" {
  type        = string
  description = "The type of replication to use for this storage account. This can either be LRS, GRS, RAGRS, ZRS or GZRS"
  default     = "ZRS"

  validation {
    condition     = var.account_replication_type == "GRS" || var.account_replication_type == "RAGRS" || var.account_replication_type == "ZRS" || var.account_replication_type == "GZRS"
    error_message = "The account replication type must be either GRS, RAGRS, ZRS or GZRS. We specifically disallow Zone Redundant Storage (ZRS)"
  }
}

variable "environment" {
  type        = string
  description = "The environment this resource is being deployed to. This can either be dev, test, staging or prod"
  default     = "dev"

  validation {
    condition     = var.environment == "dev" || var.environment == "test" || var.environment == "staging" || var.environment == "prod"
    error_message = "The environment must be either dev, test, staging or prod"
  }
}


resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = "${var.azure_region}"
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "storage-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes      = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_storage_account" "example" {
  name                = "${var.prefix}vnet"
  resource_group_name = azurerm_resource_group.example.name

  location                          = azurerm_resource_group.example.location
  account_tier                      = "Standard"
  account_replication_type          = "${var.account_replication_type}"
  cross_tenant_replication_enabled  = false
  enable_https_traffic_only         = true
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  shared_access_key_enabled         = true //Setting this to false doesn't work with the terraform azurerm provider due to dataplane api limitations
  default_to_oauth_authentication   = true 
  nfsv3_enabled                    = false
  infrastructure_encryption_enabled = true
  allowed_copy_scope                = "AAD"

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = ["${azurerm_subnet.example.id}"]
  }

  tags = {
    environment = "${var.environment}"
  }
}

output "virtual_network_name" {
  value = azurerm_virtual_network.example.name
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}