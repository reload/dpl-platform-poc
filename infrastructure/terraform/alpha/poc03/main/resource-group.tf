variable "location" {}
variable "env_name" {}

resource "azurerm_resource_group" "poc3" {
  name     = "poc03-${var.env_name}"
  location = var.location
}
