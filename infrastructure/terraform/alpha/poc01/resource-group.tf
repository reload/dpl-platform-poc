resource "azurerm_resource_group" "rg" {
  name     = "poc01"
  location = var.location
}
