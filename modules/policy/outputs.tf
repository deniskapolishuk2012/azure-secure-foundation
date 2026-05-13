output "policy_definition_ids" {
  description = "Map of policy definition IDs"
  value       = { for k, v in azurerm_policy_definition.this : k => v.id }
}
