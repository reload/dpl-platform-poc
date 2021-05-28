resource "azurerm_public_ip" "aks_egress" {
  name                = "aksEgress"
  sku                 = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "dplpoc01eg"
}

resource "azurerm_public_ip" "aks_ingress" {
  name                = "aksIngress"
  sku                 = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "dplpoc01ing"
}

resource "azurerm_virtual_network" "aks" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                = "aks-subnet"
  resource_group_name = azurerm_resource_group.rg.name

  address_prefixes            = ["192.168.1.0/24"]
  virtual_network_name        = azurerm_virtual_network.aks.name
  service_endpoints           = ["Microsoft.Sql", "Microsoft.Storage"]
  service_endpoint_policy_ids = [azurerm_subnet_service_endpoint_storage_policy.storage.id]
}

resource "azurerm_subnet_service_endpoint_storage_policy" "storage" {
  name                = "storage-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  definition {
    name        = "aksAccess"
    description = "aksAccess"
    service_resources = [
      azurerm_resource_group.rg.id,
      azurerm_storage_account.storage.id
    ]
  }
}

output "ingress_ip" {
  value = azurerm_public_ip.aks_ingress.ip_address
}

output "egress_ip" {
  value = azurerm_public_ip.aks_egress.ip_address
}
