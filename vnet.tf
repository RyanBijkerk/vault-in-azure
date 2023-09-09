resource "azurerm_virtual_network" "vnet" {
  name          = "golab-vnet"
  address_space = ["10.0.0.0/16"]
  dns_servers   = [cidrhost("10.0.200.0/24", 10)]

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "mgmt" {
  name                 = "golab-mgmt"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.200.0/24"]
}

resource "azurerm_subnet" "docker" {
  name                 = "golab-docker"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.124.0/24"]

  delegation {
    name = "dl-docker"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }

  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}

resource "azurerm_network_profile" "docker" {
  name                = "np-docker"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  container_network_interface {
    name = "nic-docker"

    ip_configuration {
      name      = "ip-docker"
      subnet_id = azurerm_subnet.docker.id
    }
  }
}