# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Private Link Endpoints for Azure Monitor
#---------------------------------------------------------
resource "azurerm_private_endpoint" "ampls" {
  name                = local.private_endpoint_name
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.existing_ampls_private_subnet_id
  tags                = merge(local.default_tags, var.add_tags)

  private_dns_zone_group {
    name                 = "ampls-default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  private_service_connection {
    name                           = local.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = var.azurerm_monitor_private_link_scope_id == null ? join("", azurerm_monitor_private_link_scope.main.*.id) : var.azurerm_monitor_private_link_scope_id
    subresource_names              = ["azuremonitor"]
  }
}


