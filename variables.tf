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