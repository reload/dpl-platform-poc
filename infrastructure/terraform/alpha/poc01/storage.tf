resource "random_id" "storage_account" {
  byte_length = 4
}

resource "azurerm_storage_account" "storage" {
  name                     = "stdpl${var.workspace}${random_id.storage_account.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

