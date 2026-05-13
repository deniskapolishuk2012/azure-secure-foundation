output "require_mfa_policy_id" {
  value = azuread_conditional_access_policy.require_mfa.id
}

output "block_legacy_auth_policy_id" {
  value = azuread_conditional_access_policy.block_legacy_auth.id
}
