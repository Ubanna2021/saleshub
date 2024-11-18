# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acrName
  resource_group_name = var.rgName
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}
