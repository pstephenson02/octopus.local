provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "octopetshop_demo" {
  name     = var.azure_resource_group_name
  location = "West US 2"
}

resource "azurerm_mssql_server" "ops_mssql_server" {
  name                         = "ops-demo"
  resource_group_name          = azurerm_resource_group.octopetshop_demo.name
  location                     = azurerm_resource_group.octopetshop_demo.location
  administrator_login          = var.ops_database_credentials.username
  administrator_login_password = var.ops_database_credentials.password
  version                      = "12.0"
}
