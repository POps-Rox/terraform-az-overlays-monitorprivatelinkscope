# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# Outputs    ##
###############

# Add outputs for the resource
output "azurerm_monitor_private_link_scope_id" {
  value       = azurerm_monitor_private_link_scope.main.id
  description = "The ID of the Azure Monitor Private Link Scope."
}

output "azurerm_monitor_private_link_scope_name" {
  value       = azurerm_monitor_private_link_scope.main.name
  description = "The name of the Azure Monitor Private Link Scope."
}

output "azurerm_monitor_private_link_scoped_service_id" {
  value       = azurerm_monitor_private_link_scoped_service.main[*].id
  description = "The ID of the Azure Monitor Private Link Scoped Service."
}

output "azurerm_monitor_private_link_scoped_service_name" {
  value       = azurerm_monitor_private_link_scoped_service.main[*].name
  description = "The name of the Azure Monitor Private Link Scoped Service."
}

