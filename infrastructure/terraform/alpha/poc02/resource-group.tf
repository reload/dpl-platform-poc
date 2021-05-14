variable "location" {}

resource "azurerm_resource_group" "poc02" {
  name     = "poc02"
  location = var.location
}
