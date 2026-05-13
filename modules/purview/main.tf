resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_purview_account" "this" {
  name                = "purview-asf-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = "westeurope"

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}
