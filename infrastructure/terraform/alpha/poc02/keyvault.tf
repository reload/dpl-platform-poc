resource "random_id" "keyvault" {
  byte_length = 2
}

data "azuread_group" "contributors" {
  display_name = "contributors"
}

resource "azurerm_key_vault" "keyvault" {
  name                       = "keyvault${random_id.keyvault.hex}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_group.contributors.object_id

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover",
      "list"
    ]
  }
}

output "keyvault_name" {
  value = azurerm_key_vault.keyvault.name
}
