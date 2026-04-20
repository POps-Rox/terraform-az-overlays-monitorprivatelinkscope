# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
#------------------------------------------------------------
data "popsrox_resource_name" "azurerm_private_endpoint" {
  name          = var.workload_name
  resource_type = "azurerm_private_endpoint"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : local.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "pe"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "popsrox_resource_name" "azurerm_private_service_connection" {
  name          = var.workload_name
  resource_type = "azurerm_private_service_connection"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : local.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "psc"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "popsrox_resource_name" "azurerm_private_dns_a_record" {
  name          = var.workload_name
  resource_type = "azurerm_private_dns_a_record"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : local.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "pdnsrec"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "popsrox_resource_name" "azurerm_private_link_service" {
  name          = var.workload_name
  resource_type = "azurerm_private_link_service"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : local.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "pls"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
