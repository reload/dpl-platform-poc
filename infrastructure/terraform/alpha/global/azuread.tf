data "azurerm_subscription" "primary" {
}

# Setup an AD Group that will contain "Contributors" - administrators that
# should have full access.
resource "azuread_group" "contributors" {
  display_name = "contributors"
  members = [
    # Mads
    "d361fc8c-46fe-4566-8492-22b82404bc15",
    # Mikkel
    "7fea7f9f-3049-4131-9fab-6d55fc28988f"
  ]
}

# Grant all members of the contributor group the Contributor RBAC role
resource "azurerm_role_assignment" "contributor_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.contributors.object_id
}
