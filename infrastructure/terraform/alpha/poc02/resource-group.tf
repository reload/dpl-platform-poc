# variable "location" {}
# variable "workspace" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.workspace}-rg"
  location = var.location
}
