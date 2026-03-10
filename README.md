<!-- BADGES:START -->
[![CI](https://github.com/POps-Rox/tf-az-overlays-monitorprivatelinkscope/actions/workflows/ci.yml/badge.svg)](https://github.com/POps-Rox/tf-az-overlays-monitorprivatelinkscope/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/POps-Rox/tf-az-overlays-monitorprivatelinkscope/pulls)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/POps-Rox/tf-az-overlays-monitorprivatelinkscope/graphs/commit-activity)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4.svg?logo=terraform)](https://www.terraform.io)
<!-- BADGES:END -->

# Azure Monitor Private Link Scope (AMPLS) Overlay Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-azure-monitor-private-link-scope/azurerm/)

This Overlay terraform module can create a Azure Monitor Private Link Scope connects a Private Endpoint to a set of Azure Monitor resources as [Azure Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview). It is a managed service that is deployed and managed by Microsoft. It is not a service that you deploy and manage yourself. It is a service that you deploy into a VNet and then connect to other Azure Monitor services and manage related parameters to define the boundaries of your monitoring network. This module can be used in a [SCCA compliant Network](https://registry.terraform.io/modules/azurenoops/overlays-hubspoke/azurerm/latest).

## Using Azure Clouds

Since this module is built for both public and us government clouds. The `environment` variable defaults to `public` for Azure Cloud. When using this module with the Azure Government Cloud, you must set the `environment` variable to `usgovernment`. You will also need to set the azurerm provider `environment` variable to the proper cloud as well. This will ensure that the correct Azure Government Cloud endpoints are used. You will also need to set the `location` variable to a valid Azure Government Cloud location.

Example Usage for Azure Government Cloud:

```hcl

provider "azurerm" {
  environment = "usgovernment"
}

module "mod_ampls" {
  source  = "azurenoops/overlays-azure-monitor-private-link-scope/azurerm"
  version = "x.x.x"
  
  location = "usgovvirginia"
  environment = "usgovernment"
  ...
}

```

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation](https://github.com/azurenoops/terraform-azurerm-overlays-compute-image-gallery/blob/main).

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## License

This Terraform module is open-sourced software licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Resources Supported

- [Azure Monitor Private Link Scope](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_link_scope)

## Module Usage

```hcl
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_ampls" {
  source  = "azurenoops/overlays-azure-monitor-private-link-scope/azurerm"
  version = "x.x.x"

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
  private_dns_zone_ids = [module.mod_hub_network.private_dns_zone_ids["privatelink.agentsvc.azure-automation.net"].id]

  # Private Endpoint details
  # Resource Group, location, VNet and Subnet details
  # This need to be the same as the VNet and Subnet where the Private Endpoint will be deployed
  existing_ampls_virtual_network_id     = module.mod_ops_network.virtual_network_id
  existing_ampls_private_subnet_id      = module.mod_ops_network.subnet_ids["ampls"].id
  
  # Tags
  add_tags = {} # Tags to be applied to all resources
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mod_azure_region_lookup"></a> [mod\_azure\_region\_lookup](#module\_mod\_azure\_region\_lookup) | azurenoops/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| <a name="module_mod_pdz"></a> [mod\_pdz](#module\_mod\_pdz) | azurenoops/overlays-private-dns-zone/azurerm | ~> 1.0 |
| <a name="module_mod_scaffold_rg"></a> [mod\_scaffold\_rg](#module\_mod\_scaffold\_rg) | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_private_link_scope.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_private_link_scope) | resource |
| [azurerm_monitor_private_link_scoped_service.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_private_link_scoped_service) | resource |
| [azurerm_private_endpoint.ampls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurenoopsutils_resource_name.azurerm_private_dns_a_record](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.azurerm_private_endpoint](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.azurerm_private_link_service](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.azurerm_private_service_connection](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_azurerm_monitor_private_link_scope_id"></a> [azurerm\_monitor\_private\_link\_scope\_id](#input\_azurerm\_monitor\_private\_link\_scope\_id) | The id of the private link scope to link to the private link service, if not set, a new private link scope will be created | `string` | `null` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_custom_private_dns_a_record_name"></a> [custom\_private\_dns\_a\_record\_name](#input\_custom\_private\_dns\_a\_record\_name) | The name of the custom private dns a record to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_private_dns_zone_name"></a> [custom\_private\_dns\_zone\_name](#input\_custom\_private\_dns\_zone\_name) | The name of the custom private dns zone to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_private_endpoint_name"></a> [custom\_private\_endpoint\_name](#input\_custom\_private\_endpoint\_name) | The name of the custom private endpoint to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_private_link_service_name"></a> [custom\_private\_link\_service\_name](#input\_custom\_private\_link\_service\_name) | The name of the custom private link service to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_private_service_connection_name"></a> [custom\_private\_service\_connection\_name](#input\_custom\_private\_service\_connection\_name) | The name of the custom private service connection to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | Name of the workload's environment | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| <a name="input_existing_ampls_private_subnet_id"></a> [existing\_ampls\_private\_subnet\_id](#input\_existing\_ampls\_private\_subnet\_id) | (Required) ID of the subnet for ampls | `any` | `null` | no |
| <a name="input_existing_ampls_virtual_network_id"></a> [existing\_ampls\_virtual\_network\_id](#input\_existing\_ampls\_virtual\_network\_id) | (Required) ID of the virtual network for ampls | `any` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_linked_log_analytic_workspace_ids"></a> [linked\_log\_analytic\_workspace\_ids](#input\_linked\_log\_analytic\_workspace\_ids) | (Required) The id of the log analytic workspace to link to the private link service | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | The ids of the private dns zone to link to the private link service | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | `"ampls"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_monitor_private_link_scope_id"></a> [azurerm\_monitor\_private\_link\_scope\_id](#output\_azurerm\_monitor\_private\_link\_scope\_id) | The ID of the Azure Monitor Private Link Scope. |
| <a name="output_azurerm_monitor_private_link_scope_name"></a> [azurerm\_monitor\_private\_link\_scope\_name](#output\_azurerm\_monitor\_private\_link\_scope\_name) | The name of the Azure Monitor Private Link Scope. |
| <a name="output_azurerm_monitor_private_link_scoped_service_id"></a> [azurerm\_monitor\_private\_link\_scoped\_service\_id](#output\_azurerm\_monitor\_private\_link\_scoped\_service\_id) | The ID of the Azure Monitor Private Link Scoped Service. |
| <a name="output_azurerm_monitor_private_link_scoped_service_name"></a> [azurerm\_monitor\_private\_link\_scoped\_service\_name](#output\_azurerm\_monitor\_private\_link\_scoped\_service\_name) | The name of the Azure Monitor Private Link Scoped Service. |
<!-- END_TF_DOCS -->
