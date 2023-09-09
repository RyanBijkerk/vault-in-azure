resource "random_integer" "vault" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "vault" {
  name                     = "vault${random_integer.vault.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "vault" {
  name                 = "vault"
  storage_account_name = azurerm_storage_account.vault.name
  quota                = 50

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_storage_share_directory" "config-dir" {
  name                 = "config"
  share_name           = azurerm_storage_share.vault.name
  storage_account_name = azurerm_storage_account.vault.name

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_storage_share_directory" "file-dir" {
  name                 = "file"
  share_name           = azurerm_storage_share.vault.name
  storage_account_name = azurerm_storage_account.vault.name

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_storage_share_file" "file" {
  name             = "config.hcl"
  path             = azurerm_storage_share_directory.config-dir.name
  storage_share_id = azurerm_storage_share.vault.id
  source           = "./config/vault/config.hcl"

  lifecycle {
    ignore_changes = all
  }
}