resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${var.workspace}-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.workspace

  default_node_pool {
    name       = var.node_pool_name
    node_count = var.node_pool_node_count
    vm_size    = var.cluster_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }
}

data "azurerm_client_config" "current" {}
