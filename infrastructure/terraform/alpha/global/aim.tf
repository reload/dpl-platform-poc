data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "kv" {
  name                = "kv-alpha-005-tfstate"
  resource_group_name = "rg-dpl-poc-alpha-tfstate-005"
}

# Allow the contributors to read secrets from the keyvault. This is use by the
# Terraform setup to read the Storage Account Key needed to read and write
# the state.
resource "azurerm_key_vault_access_policy" "contributor_manage_secret_policy" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_group.contributors.object_id

  secret_permissions = [
    "List",
    "Get"
  ]
}
