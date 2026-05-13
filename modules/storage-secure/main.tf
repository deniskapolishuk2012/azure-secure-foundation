resource "azurerm_storage_account" "this" {
  name                     = "stasf${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  default_to_oauth_authentication  = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    versioning_enabled = true
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = []
  }

  tags = var.common_tags
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
