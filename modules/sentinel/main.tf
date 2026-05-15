resource "azurerm_sentinel_log_analytics_workspace_onboarding" "this" {
  workspace_id = var.log_analytics_workspace_id
}

resource "azurerm_sentinel_alert_rule_scheduled" "keyvault_suspicious_access" {
  name                       = "ASF-KeyVault-Suspicious-Access"
  log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.this.workspace_id
  display_name               = "ASF-KeyVault-Suspicious-Access"
  severity                   = "Medium"
  enabled                    = true

  query = <<-EOT
    AzureDiagnostics
    | where ResourceType == "VAULTS"
    | where ResultType == "Unauthorized" or ResultType == "Forbidden"
    | summarize Count = count() by CallerIPAddress, bin(TimeGenerated, 1h)
    | where Count > 2
  EOT

  query_frequency = "PT1H"
  query_period    = "PT1H"

  trigger_operator  = "GreaterThan"
  trigger_threshold = 0

  tactics = ["CredentialAccess"]
}

resource "azurerm_sentinel_alert_rule_scheduled" "failed_signins" {
  name                       = "ASF-Failed-SignIns"
  log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.this.workspace_id
  display_name               = "ASF-Failed-SignIns"
  severity                   = "High"
  enabled                    = true

  query = <<-EOT
    SigninLogs
    | where ResultType != "0"
    | summarize FailureCount = count() by UserPrincipalName, IPAddress, bin(TimeGenerated, 1h)
    | where FailureCount > 5
  EOT

  query_frequency = "PT1H"
  query_period    = "PT1H"

  trigger_operator  = "GreaterThan"
  trigger_threshold = 0

  tactics = ["CredentialAccess"]
}
