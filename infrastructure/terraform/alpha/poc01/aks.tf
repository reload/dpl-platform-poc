resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.workspace

  default_node_pool {
    name           = "system"
    node_count     = var.node_pool_node_count
    vnet_subnet_id = azurerm_subnet.aks.id

    vm_size            = var.cluster_vm_size
    availability_zones = ["1"]

  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"

    load_balancer_sku = "Standard"
    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.aks_egress.id]
    }
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
