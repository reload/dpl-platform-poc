
resource "azurerm_storage_account" "storage" {
  name                     = "stdplpocpoc0202"
  resource_group_name      = azurerm_resource_group.poc02.name
  location                 = azurerm_resource_group.poc02.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

