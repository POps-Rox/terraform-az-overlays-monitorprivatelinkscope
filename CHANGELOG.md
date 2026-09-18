# Unreleased

Changed
- Upgrade root `azurerm` constraint to `>= 5.0, < 6.0` and examples to `~> 5.6`.
- Add mock-provider `terraform test` coverage for naming, resource-group selection, tags, and location passthrough.
- Apply default tag merging to the private link scope and private endpoint.

# v2.0.0 - 2026-05-11

Changed
- **BREAKING**: Upgrade `azurerm` provider to `~> 4.20` (was `~> 3.116`).
- **BREAKING**: Raise minimum Terraform CLI to `>= 1.10` (was `>= 1.9`).
- Declare `azapi ~> 2.0` provider for fleet alignment.
- Examples: pin matching provider versions; add `subscription_id` env-var hint
  (azurerm 4.x requires `ARM_SUBSCRIPTION_ID` for apply; `validate` unaffected).
- No resource-attribute renames triggered. `azurerm_monitor_private_link_scope` and `azurerm_monitor_private_link_scoped_service` are 4.x-compatible without code changes.

Notes
- Cross-module dependency: transitive sibling overlays must also ship 4.x-compatible
  releases before this version can resolve cleanly via `terraform init -upgrade`.

# v1.0.0 - <date>

Added
- Add Something you added
