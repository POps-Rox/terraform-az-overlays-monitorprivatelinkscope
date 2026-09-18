# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------------
# Private Link Scope for Azure Monitor
#---------------------------------------------------------------

resource "azurerm_monitor_private_link_scope" "main" {
  name                = format("%s-%s-ampls-%s-pls", var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : local.location, var.deploy_environment)
  resource_group_name = local.resource_group_name
  tags                = merge(local.default_tags, var.add_tags)
}

resource "azurerm_monitor_private_link_scoped_service" "main" {
  count               = length(var.linked_log_analytic_workspace_ids) > 0 ? length(var.linked_log_analytic_workspace_ids) : 0
  name                = format("%s-0%s", local.private_link_service_name, count.index + 1)
  resource_group_name = local.resource_group_name
  scope_name          = join("", azurerm_monitor_private_link_scope.main.*.name)
  linked_resource_id  = element(var.linked_log_analytic_workspace_ids, count.index)
}

