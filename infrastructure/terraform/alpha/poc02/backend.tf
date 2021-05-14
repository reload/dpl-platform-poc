terraform {
  backend "azurerm" {
    storage_account_name = "stdplpocalphatf005"
    container_name       = "state"
    key                  = "alpha.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.58.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "3b95f745-ffb4-4ff8-b3f9-45308d6fc4b8"
}
