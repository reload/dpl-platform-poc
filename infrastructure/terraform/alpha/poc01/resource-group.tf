variable "location" {}

resource "azurerm_resource_group" "poc01" {
  name     = "poc01"
  location = var.location
}
