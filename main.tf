terraform {
  required_providers {
    octopusdeploy = {
      source = "OctopusDeployLabs/octopusdeploy"
    }
  }
}

provider "octopusdeploy" {
  address    = var.octopus_server_address
  api_key    = var.octopus_api_key
  space_name = "Default"
}

resource "octopusdeploy_environment" "development" {
  name       = "Development"
  sort_order = 1
}

resource "octopusdeploy_environment" "staging" {
  name       = "Staging"
  sort_order = 2
}

resource "octopusdeploy_environment" "production" {
  name       = "Production"
  sort_order = 3
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

resource "octopusdeploy_listening_tentacle_deployment_target" "ops-database-runner" {
  environments                      = [octopusdeploy_environment.development.id, octopusdeploy_environment.staging.id, octopusdeploy_environment.production.id]
  name                              = "OctoPetShop Database Runner"
  roles                             = ["db"]
  tenanted_deployment_participation = "Untenanted"
  tentacle_url                      = var.ops_db_runner.tentacle_url
  thumbprint                        = var.ops_db_runner.tentacle_thumbprint
}

resource "octopusdeploy_nuget_feed" "ops_nuget_feed" {
  feed_uri                       = "https://nuget.pkg.github.com/${var.github_credentials.username}/index.json"
  is_enhanced_mode               = true
  name                           = "${var.github_credentials.username} GitHub NuGet Feed"
  username                       = var.github_credentials.username
  password                       = var.github_credentials.token
}

data "octopusdeploy_lifecycles" "default_lifecycle" {
  partial_name = "Default"
  take         = 1
}

resource "octopusdeploy_project_group" "dotnet" {
  name        = ".NET"
  description = ".NET based projects"
}

resource "octopusdeploy_project" "octopetshop" {
  lifecycle_id     = data.octopusdeploy_lifecycles.default_lifecycle.lifecycles[0].id
  name             = "OctoPetShop"
  project_group_id = octopusdeploy_project_group.dotnet.id
}

resource "octopusdeploy_deployment_process" "ops_deployment_process" {
  project_id = octopusdeploy_project.octopetshop.id
  step {
    condition = "Success"
    name      = "Run Database Migrations"
    target_roles = ["db"]
    deploy_package_action {
      name        = "Run Database Migrations"
      primary_package {
        package_id = "OctopusDeploy.OctoPetShop.Database"
        feed_id    = octopusdeploy_nuget_feed.ops_nuget_feed.id
        acquisition_location = "Server"
        properties = {
          "SelectionMode" = "immediate"
        }
      }
      features = ["Octopus.Features.CustomScripts"]
      properties = {
        "Octopus.Action.EnabledFeatures"              = "Octopus.Features.CustomScripts"
        "Octopus.Action.CustomScripts.PostDeploy.ps1" = <<-EOT
            $connectionString = $OctopusParameters["${octopusdeploy_variable.ops_database_connection_string.name}"]
            .\OctopusDeploy.OctoPetShop.Database.exe --ConnectionString="$connectionString"
        EOT
        "Octopus.Action.Package.PackageId" = "OctopusDeploy.OctoPetShop.Database",
        "Octopus.Action.Package.FeedId" = octopusdeploy_nuget_feed.ops_nuget_feed.id,
        "Octopus.Action.Package.DownloadOnTentacle" = "False"
      }
    }
  }
}