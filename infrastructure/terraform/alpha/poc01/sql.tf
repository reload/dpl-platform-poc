
resource "random_password" "sql_pass" {
  length           = 16
  special          = true
  override_special = "_%@"
  keepers = {
    login_seed = var.sql_login_seed
  }
}

resource "random_string" "sql_user" {
  length  = 10
  special = false
  keepers = {
    login_seed = var.sql_login_seed
  }
}

resource "random_id" "mariadb" {
  byte_length = 2
}

resource "azurerm_mariadb_server" "sql" {
  name                = "dplpocmariadb${random_id.mariadb.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # The username is required to begin with an alpha char.
  administrator_login          = "q${random_string.sql_user.result}"
  administrator_login_password = random_password.sql_pass.result

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled            = true
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  # We could consider using this feature, but be aware that it is not available
  # for all tiers: https://docs.microsoft.com/en-us/azure/mysql/concepts-data-access-security-private-link
  public_network_access_enabled = true
  ssl_enforcement_enabled       = true
}

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

resource "azurerm_key_vault_secret" "sql_user" {
  name         = "sql-user"
  value        = random_string.sql_user.result
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "sql_pass" {
  name         = "sql-pass"
  value        = random_password.sql_pass.result
  key_vault_id = azurerm_key_vault.keyvault.id
}
