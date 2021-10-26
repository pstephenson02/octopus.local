variable "octopus_server_address" {
  description = "The URL (including schema) to the Octopus Server. ex: https://example.octopus.com"
  type        = string
}

variable "octopus_api_key" {
  description = "Octopus API Key"
  type        = string
  sensitive   = true
}

variable "azure_service_principal" {
  type = object({
    application_id = string
    password = string
    subscription_id = string
    subscription_id = string
    tenant_id = string
    name = string
  })
  sensitive = true
}

variable "github_credentials" {
  type = object({
    username = string
    token = string
  })
  sensitive = true
}

variable "ops_database_credentials" {
  type = object({
    username = string
    password = string
  })
  sensitive = true
}


variable "ops_sql_server" {
  description = "SQL Server name"
  type        = string
}

variable "ops_db_runner" {
  type = object({
    tentacle_url = string
    tentacle_thumbprint = string
  })
}