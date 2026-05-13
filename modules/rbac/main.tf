resource "azurerm_role_definition" "security_reader" {
  name        = "ASF Security Reader"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Read-only access to security resources — Key Vault, Policy, RBAC"

  permissions {
    actions = [
      "Microsoft.KeyVault/vaults/read",
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/policyAssignments/read",
      "Microsoft.Authorization/policyDefinitions/read",
      "Microsoft.Security/*/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}"
  ]
}

resource "azurerm_role_definition" "security_operator" {
  name        = "ASF Security Operator"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Operate security resources — manage Key Vault secrets, review policies"

  permissions {
    actions = [
      "Microsoft.KeyVault/vaults/read",
      "Microsoft.KeyVault/vaults/secrets/*",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/policyAssignments/read",
      "Microsoft.Authorization/policyDefinitions/read",
      "Microsoft.Security/*/read",
      "Microsoft.Insights/diagnosticSettings/*"
    ]
    not_actions = [
      "Microsoft.KeyVault/vaults/write",
      "Microsoft.KeyVault/vaults/delete",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete"
    ]
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}"
  ]
}
