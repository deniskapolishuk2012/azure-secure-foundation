data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = "kv-asf-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization   = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 90
  enabled_for_disk_encryption     = false
  enabled_for_deployment          = false
  enabled_for_template_deployment = false

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = []
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.common_tags
}

resource "azurerm_management_lock" "key_vault" {
  name       = "lock-kv-asf"
  scope      = azurerm_key_vault.this.id
  lock_level = "CanNotDelete"
  notes      = "Managed by Terraform — do not delete manually"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
