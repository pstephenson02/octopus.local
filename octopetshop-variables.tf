resource "octopusdeploy_variable" "appsettings_environment_name" {
  name = "AppSettings:EnvironmentName"
  value = "#{Octopus.Environment.Name}"
  type = "String"
  owner_id = octopusdeploy_project.octopetshop.id
}

resource "octopusdeploy_variable" "ops_database_name" {
  name = "OctoPetShop.Database.Name"
  value = "ops-#{Octopus.Environment.Name | ToLower}"
  type = "String"
  owner_id = octopusdeploy_project.octopetshop.id
}

resource "octopusdeploy_variable" "ops_database_username" {
  name = "OctoPetShop.Database.User"
  value = var.ops_database_credentials.username
  type = "String"
  owner_id = octopusdeploy_project.octopetshop.id
}

resource "octopusdeploy_variable" "ops_database_password" {
  name = "OctoPetShop.Database.Password"
  value = var.ops_database_credentials.password
  is_sensitive = true
  type = "Sensitive"
  owner_id = octopusdeploy_project.octopetshop.id
}

resource "octopusdeploy_variable" "ops_database_connection_string" {
  name = "ConnectionStrings:OPSConnectionString"
  value = "Server=tcp:${var.ops_sql_server},1433;Initial Catalog=#{OctoPetShop.Database.Name};Persist Security Info=False;User ID=#{OctoPetShop.Database.User};Password=#{OctoPetShop.Database.Password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  type = "String"
  owner_id = octopusdeploy_project.octopetshop.id
}

resource "octopusdeploy_variable" "ops_product_api_base_url" {
  name = "AppSettings:ProductApiBaseUrl"
  value = "https://ops-api-#{Octopus.Environment.Name | ToLower}.azurewebsites.net"
  type = "String"
  owner_id = octopusdeploy_project.octopetshop.id
}
