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

resource "octopusdeploy_azure_web_app_deployment_target" "ops-web-development" {
  account_id                        = octopusdeploy_azure_service_principal.octopusdeploy_onmicrosoft_com.id
  environments                      = [octopusdeploy_environment.development.id]
  name                              = "OctoPetShop Web - Development"
  resource_group_name               = "octopetshop-demo"
  roles                             = ["web"]
  tenanted_deployment_participation = "Untenanted"
  web_app_name                      = "ops-web-development"
}

resource "octopusdeploy_azure_web_app_deployment_target" "ops-web-staging" {
  account_id                        = octopusdeploy_azure_service_principal.octopusdeploy_onmicrosoft_com.id
  environments                      = [octopusdeploy_environment.staging.id]
  name                              = "OctoPetShop Web - Staging"
  resource_group_name               = "octopetshop-demo"
  roles                             = ["web"]
  tenanted_deployment_participation = "Untenanted"
  web_app_name                      = "ops-web-staging"
}

resource "octopusdeploy_azure_web_app_deployment_target" "ops-web-production" {
  account_id                        = octopusdeploy_azure_service_principal.octopusdeploy_onmicrosoft_com.id
  environments                      = [octopusdeploy_environment.production.id]
  name                              = "OctoPetShop Web - Production"
  resource_group_name               = "octopetshop-demo"
  roles                             = ["web"]
  tenanted_deployment_participation = "Untenanted"
  web_app_name                      = "ops-web-production"
}

resource "octopusdeploy_azure_web_app_deployment_target" "ops-api-development" {
  account_id                        = octopusdeploy_azure_service_principal.octopusdeploy_onmicrosoft_com.id
  environments                      = [octopusdeploy_environment.development.id]
  name                              = "OctoPetShop API - Development"
  resource_group_name               = "octopetshop-demo"
  roles                             = ["api"]
  tenanted_deployment_participation = "Untenanted"
  web_app_name                      = "ops-api-development"
}

resource "octopusdeploy_azure_web_app_deployment_target" "ops-api-staging" {
  account_id                        = octopusdeploy_azure_service_principal.octopusdeploy_onmicrosoft_com.id
  environments                      = [octopusdeploy_environment.staging.id]
  name                              = "OctoPetShop API - Staging"
  resource_group_name               = "octopetshop-demo"
  roles                             = ["api"]
  tenanted_deployment_participation = "Untenanted"
  web_app_name                      = "ops-api-staging"
}

resource "octopusdeploy_azure_web_app_deployment_target" "ops-api-production" {
  account_id                        = octopusdeploy_azure_service_principal.octopusdeploy_onmicrosoft_com.id
  environments                      = [octopusdeploy_environment.production.id]
  name                              = "OctoPetShop API - Production"
  resource_group_name               = "octopetshop-demo"
  roles                             = ["api"]
  tenanted_deployment_participation = "Untenanted"
  web_app_name                      = "ops-api-production"
}
