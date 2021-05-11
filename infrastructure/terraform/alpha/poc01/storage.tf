
resource "azurerm_storage_account" "storage" {
  name                     = "stdplpocpoc0102"
  resource_group_name      = azurerm_resource_group.poc01.name
  location                 = azurerm_resource_group.poc01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

