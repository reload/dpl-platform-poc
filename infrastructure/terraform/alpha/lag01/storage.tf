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

resource "azurerm_storage_share" "bulk" {
  name                 = "bulk"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
}

resource "azurerm_key_vault_secret" "storage_primary_access_key" {
  name         = "storage-primary-access-key"
  value        = azurerm_storage_account.storage.primary_access_key
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "secondary_access_key" {
  name         = "storage-secondary-access-key"
  value        = azurerm_storage_account.storage.secondary_access_key
  key_vault_id = azurerm_key_vault.keyvault.id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_share_name" {
  value = azurerm_storage_share.bulk.name
}
