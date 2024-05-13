terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "itaeactionstfapply"
    storage_account_name = "itaeactionstfapply"
    container_name       = "itaeactionstfapply"
    location             = "southcentralus"
  }
}

resource "azurerm_storage_account" "test_storage_account" {
  name                     = "itaeactionstfapplytest"
  resource_group_name      = "itaeactionstfapplytest"
  location                 = "southcentralus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
