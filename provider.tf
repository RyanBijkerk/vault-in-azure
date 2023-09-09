terraform {

  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.9"
    }

    random = {
      source = "hashicorp/random"
      version = ">=3.4"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}
