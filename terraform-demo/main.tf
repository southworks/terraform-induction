# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
  #Does not allow to use variables here
  #This resources MUST exist before run the script
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-demo-southies"
  #   storage_account_name = "stterraformsouthies"
  #   container_name       = "terraform"
  #   key                  = "DeployData0000.tfstate"
  # }
}

provider "azurerm" {

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

data "azurerm_subscription" "demo" {
}

resource "azurerm_resource_group" "demo" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "demo" {
  name                     = "stdemovendoreastus001"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  tags                     = azurerm_resource_group.demo.tags
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
}

resource "azurerm_app_service_plan" "demo" {
  name                = "sp-demo-vendor-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  tags = azurerm_resource_group.demo.tags
}

resource "azurerm_media_services_account" "demo" {
  name                = var.ams_account
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  storage_account {
    id         = azurerm_storage_account.demo.id
    is_primary = true
  }
}

resource "azurerm_function_app" "demo" {
  name                       = var.function_name
  location                   = azurerm_resource_group.demo.location
  resource_group_name        = azurerm_resource_group.demo.name
  app_service_plan_id        = azurerm_app_service_plan.demo.id
  storage_account_name       = azurerm_storage_account.demo.name
  storage_account_access_key = azurerm_storage_account.demo.primary_access_key
  tags                       = azurerm_resource_group.demo.tags
  identity {
    type = "SystemAssigned"
  }
  version = "~3"
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"             = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE"             = "1"
    "MediaServiceConnection:AccountName"   = var.ams_account
    "MediaServiceConnection:ResourceGroup" = var.rg_name
    "AppReg:SubscriptionId"                = data.azurerm_subscription.demo.subscription_id
  }
}

resource "azurerm_role_assignment" "demo" {
  scope                            = azurerm_media_services_account.demo.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_function_app.demo.identity[0].principal_id
  skip_service_principal_aad_check = true
}
