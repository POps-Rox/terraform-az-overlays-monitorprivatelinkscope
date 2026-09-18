# Functional tests for the Azure Monitor Private Link Scope overlay.
#
# These use mock_provider, so they run without Azure credentials.

mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      name     = "rg-existing"
      location = "westus2"
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing"
    }
  }
}

mock_provider "azapi" {}

mock_provider "popsrox" {
  mock_data "popsrox_resource_name" {
    defaults = {
      result = "generated-monitor-name"
    }
  }
}

override_module {
  target = module.mod_azure_region_lookup
  outputs = {
    location_cli   = "eastus"
    location_short = "eus"
  }
}

override_module {
  target = module.mod_scaffold_rg
  outputs = {
    resource_group_name     = "rg-created"
    resource_group_location = "eastus"
  }
}

variables {
  location                          = "eastus"
  environment                       = "public"
  deploy_environment                = "dev"
  workload_name                     = "monitor"
  org_name                          = "anoa"
  existing_resource_group_name      = "rg-existing"
  existing_ampls_private_subnet_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/snet-ampls"
  existing_ampls_virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-main"
  linked_log_analytic_workspace_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law-one",
  ]
  private_dns_zone_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-dns/providers/Microsoft.Network/privateDnsZones/privatelink.monitor.azure.com",
  ]
}

run "generated_names_are_used_when_custom_names_are_unset" {
  command = plan

  assert {
    condition     = azurerm_private_endpoint.ampls.name == "generated-monitor-name"
    error_message = "Expected generated private endpoint name when custom_private_endpoint_name is unset."
  }

  assert {
    condition     = azurerm_private_endpoint.ampls.private_service_connection[0].name == "generated-monitor-name"
    error_message = "Expected generated private service connection name when custom_private_service_connection_name is unset."
  }
}

run "custom_names_override_generated_names" {
  command = plan

  variables {
    custom_private_endpoint_name           = "explicit-pe"
    custom_private_service_connection_name = "explicit-psc"
  }

  assert {
    condition     = azurerm_private_endpoint.ampls.name == "explicit-pe"
    error_message = "custom_private_endpoint_name must take precedence over generated naming."
  }

  assert {
    condition     = azurerm_private_endpoint.ampls.private_service_connection[0].name == "explicit-psc"
    error_message = "custom_private_service_connection_name must take precedence over generated naming."
  }
}

run "empty_custom_names_fall_through_to_generated_names" {
  command = plan

  variables {
    custom_private_endpoint_name           = ""
    custom_private_service_connection_name = ""
  }

  assert {
    condition     = azurerm_private_endpoint.ampls.name == "generated-monitor-name"
    error_message = "Empty custom_private_endpoint_name must fall through to generated naming."
  }

  assert {
    condition     = azurerm_private_endpoint.ampls.private_service_connection[0].name == "generated-monitor-name"
    error_message = "Empty custom_private_service_connection_name must fall through to generated naming."
  }
}

run "existing_resource_group_path_uses_data_source_only" {
  command = plan

  variables {
    create_resource_group = false
  }

  assert {
    condition     = length(data.azurerm_resource_group.rgrp) == 1
    error_message = "create_resource_group = false must read exactly one existing resource group."
  }

  assert {
    condition     = length(module.mod_scaffold_rg) == 0
    error_message = "create_resource_group = false must not instantiate the resource group module."
  }
}

run "created_resource_group_path_uses_module_only" {
  command = plan

  variables {
    create_resource_group = true
  }

  assert {
    condition     = length(data.azurerm_resource_group.rgrp) == 0
    error_message = "create_resource_group = true must not read an existing resource group."
  }

  assert {
    condition     = length(module.mod_scaffold_rg) == 1
    error_message = "create_resource_group = true must instantiate exactly one resource group module."
  }
}

run "tags_merge_defaults_with_caller_supplied_values" {
  command = plan

  variables {
    add_tags = {
      costCenter = "cc-1234"
      owner      = "platform"
    }
  }

  assert {
    condition     = azurerm_monitor_private_link_scope.main.tags["deployedBy"] == "AzureNoOpsTF [default]"
    error_message = "Default tags must include deployedBy."
  }

  assert {
    condition     = azurerm_monitor_private_link_scope.main.tags["env"] == "public"
    error_message = "Default tags must include env from the environment input."
  }

  assert {
    condition     = azurerm_monitor_private_link_scope.main.tags["costCenter"] == "cc-1234"
    error_message = "Caller-supplied tags must be merged onto the private link scope."
  }

  assert {
    condition     = azurerm_private_endpoint.ampls.tags["owner"] == "platform"
    error_message = "Caller-supplied tags must be merged onto the private endpoint."
  }
}

run "default_tags_can_be_disabled" {
  command = plan

  variables {
    default_tags_enabled = false
    add_tags = {
      owner = "platform"
    }
  }

  assert {
    condition     = !contains(keys(azurerm_monitor_private_link_scope.main.tags), "deployedBy")
    error_message = "default_tags_enabled = false must suppress default tags."
  }

  assert {
    condition     = azurerm_monitor_private_link_scope.main.tags["owner"] == "platform"
    error_message = "Caller tags must remain when default tags are disabled."
  }
}

run "location_and_resource_group_come_from_existing_resource_group" {
  command = plan

  assert {
    condition     = azurerm_private_endpoint.ampls.location == "westus2"
    error_message = "Private endpoint location must come from the selected resource group location."
  }

  assert {
    condition     = azurerm_private_endpoint.ampls.resource_group_name == "rg-existing"
    error_message = "Private endpoint resource group must come from the selected resource group name."
  }
}
