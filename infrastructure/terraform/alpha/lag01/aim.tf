
resource "azurerm_role_assignment" "aks_vm_contributor_main_rg" {
  principal_id         = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Virtual Machine Contributor"
}

resource "azurerm_role_assignment" "aks_vm_storage_contributor_main_rg" {
  principal_id         = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Storage Account Contributor"
}

resource "azurerm_role_assignment" "aks_network_contributor_main_rg" {
  principal_id         = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
}

