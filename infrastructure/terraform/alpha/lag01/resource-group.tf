resource "azurerm_resource_group" "rg" {
  name     = "lag01"
  location = var.location
}

output "resourcegroup_name" {
  value = azurerm_resource_group.rg.name
}

