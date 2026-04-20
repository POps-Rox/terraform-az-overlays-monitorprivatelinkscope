locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name             = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location                        = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  private_endpoint_name           = coalesce(var.custom_private_endpoint_name, data.popsrox_resource_name.azurerm_private_endpoint.result)
  private_service_connection_name = coalesce(var.custom_private_service_connection_name, data.popsrox_resource_name.azurerm_private_service_connection.result)
  private_dns_a_record_name       = coalesce(var.custom_private_dns_a_record_name, data.popsrox_resource_name.azurerm_private_dns_a_record.result)
  private_link_service_name       = coalesce(var.custom_private_link_service_name, data.popsrox_resource_name.azurerm_private_link_service.result)
}
