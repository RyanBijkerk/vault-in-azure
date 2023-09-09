resource "azurerm_resource_group" "rg" {
  name     = "golab-backend"
  location = var.azure_region
}
