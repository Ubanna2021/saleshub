resource "azurerm_application_insights" "app_insights" {
  name                = "blueharvest-appinsights"
  location            = var.location
  resource_group_name = var.rgName
  application_type    = "web"
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "log-analytics-workspace"
  location            = var.location
  resource_group_name = var.rgName
  sku                 = "PerGB2018"
}