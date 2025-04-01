# Create Service Plan with explicit dependency
resource "azurerm_service_plan" "premium_plan" {
  name                = "${var.function_app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  os_type            = "Windows"
  sku_name           = "EP1"

  depends_on = [azurerm_resource_group.rg]
}

# Create Function App with dependencies on both storage and plan
resource "azurerm_windows_function_app" "function" {
  name                       = var.function_app_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  service_plan_id            = azurerm_service_plan.premium_plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      node_version = "~20"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"      = "node"
    "WEBSITE_NODE_DEFAULT_VERSION"  = "~20"
  }

  depends_on = [
    azurerm_service_plan.premium_plan,
    azurerm_storage_account.storage
  ]
}

resource "azurerm_role_assignment" "function_blob_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_function_app.function.identity[0].principal_id

  depends_on = [azurerm_windows_function_app.function]
} 
