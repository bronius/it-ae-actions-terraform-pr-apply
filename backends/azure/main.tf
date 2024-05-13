terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
  }
}

module "state_backend" {
  source = "github.com/tamu-edu/it-ae-tfmod-azure-state?ref=v0.1.1"

  storage_account_name = "itaeactionstfapply"
  container_name       = "itaeactionstfapply"
}
