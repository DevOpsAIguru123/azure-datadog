# Create Resource Group first
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Ensure storage account name is valid (lowercase, no special chars)
resource "azurerm_storage_account" "storage" {
  name                     = lower(replace(var.storage_account_name, "-", ""))
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_resource_group.rg]
}
