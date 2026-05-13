output "resource_groups" {
  description = "Created resource group names"
  value       = module.governance.resource_group_names
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.key_vault.key_vault_uri
}

output "hub_vnet_id" {
  description = "Hub VNet resource ID"
  value       = module.networking.hub_vnet_id
}
