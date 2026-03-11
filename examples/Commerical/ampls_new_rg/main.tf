# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_ampls" {
  #source  = "azurenoops/overlays-azure-monitor-private-link-scope/azurerm"
  #version = "x.x.x"
  source = "../../.."

  depends_on = [azurerm_virtual_network.example-vnet, azurerm_subnet.example-snet, azurerm_log_analytics_workspace.example-log]

  # Resource Group, location, VNet and Subnet details
  create_resource_group = true
  location              = var.location
  deploy_environment    = var.deploy_environment
  environment           = var.environment
  org_name              = var.org_name

  # Log Analytics Workspaces
  linked_log_analytic_workspace_ids = [azurerm_log_analytics_workspace.example-log.id]

  # Private DNS details
  private_dns_zone_ids = [azurerm_private_dns_zone.example-pdz[*].id]

  # Private Endpoint details
  # Resource Group, location, VNet and Subnet details
  # This need to be the same as the VNet and Subnet where the Private Endpoint will be deployed
  existing_ampls_virtual_network_id = azurerm_virtual_network.example-vnet.id
  existing_ampls_private_subnet_id  = azurerm_subnet.example-snet.id
}
