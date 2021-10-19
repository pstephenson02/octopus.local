terraform {
  required_providers {
    octopusdeploy = {
      source = "OctopusDeployLabs/octopusdeploy"
    }
  }
}

provider "octopusdeploy" {
  address = var.octopus_server_address
  api_key  = var.octopus_api_key
  space_name   = "Default"
}

resource "octopusdeploy_project_group" "dotnet" {
  name        = ".NET"
  description = ".NET based projects"
}

resource "octopusdeploy_environment" "development" {
  allow_dynamic_infrastructure = false
  description                  = ""
  name                         = "Development"
  use_guided_failure           = false
}

resource "octopusdeploy_environment" "staging" {
  allow_dynamic_infrastructure = false
  description                  = ""
  name                         = "Staging"
  use_guided_failure           = false
}

resource "octopusdeploy_environment" "production" {
  allow_dynamic_infrastructure = false
  description                  = ""
  name                         = "Production"
  use_guided_failure           = false
}

resource "octopusdeploy_azure_service_principal" "octopusdeploy_onmicrosoft_com" {
  application_id  = var.azure_service_principal.application_id
  name            = var.azure_service_principal.name
  password        = var.azure_service_principal.password
  subscription_id = var.azure_service_principal.subscription_id
  tenant_id       = var.azure_service_principal.tenant_id
  environments    = [octopusdeploy_environment.development.id, octopusdeploy_environment.staging.id, octopusdeploy_environment.production.id]
}
