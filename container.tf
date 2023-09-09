resource "azurerm_container_group" "docker" {
  name = "golab-docker"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_address_type = "Private"
  subnet_ids      = [azurerm_subnet.docker.id]
  os_type         = "Linux"

  container {
    name   = "vault"
    image  = "hashicorp/vault:latest"
    cpu    = "1"
    memory = "2"

    commands = ["/bin/sh", "-c", "vault server -config=/etc/vault/config/config.hcl"]

    ports {
      port     = 8200
      protocol = "TCP"
    }

    volume {
      name       = "vault"
      mount_path = "/etc/vault"
      read_only  = false
      share_name = azurerm_storage_share.vault.name

      storage_account_name = azurerm_storage_account.vault.name
      storage_account_key  = azurerm_storage_account.vault.primary_access_key

    }
  }
}