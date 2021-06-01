
resource "azurerm_storage_account" "sa" {
  name                     = "stdplpoc${var.workspace}02"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "sc" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "sb" {
  name                   = "stdplpoc${var.workspace}-storage-blob"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.sc.name
  type                   = "Block"
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}


output "azure_blob_storage_container_name" {
  value = azurerm_storage_blob.sb.storage_container_name
}

output "azure_blob_storage_account_name" {
  value = azurerm_storage_blob.sb.storage_account_name
}

output "azure_blob_storage_account_key" {
  sensitive = true
  value     = azurerm_storage_account.sa.primary_access_key
}
