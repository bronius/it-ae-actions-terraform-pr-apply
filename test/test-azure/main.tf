terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "itaeactionstfapply"
    container_name       = "itaeactionstfapply"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "test_storage_account" {
  name                     = "itaeactionstfapplytest"
  resource_group_name      = "terraform-state"
  location                 = "southcentralus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
