# variable "location" {}
# variable "workspace" {}
# variable "cluster_vm_size" {}
# variable "node_pool_name" {}
# variable "node_pool_node_count" {}

resource "azurerm_kubernetes_cluster" "example" {
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

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled = false
    }
  }
}