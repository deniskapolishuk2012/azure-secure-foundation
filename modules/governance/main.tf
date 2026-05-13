resource "azurerm_resource_group" "security" {
  name     = "rg-security-asf"
  location = var.location
  tags     = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_resource_group" "networking" {
  name     = "rg-networking-asf"
  location = var.location
  tags     = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_resource_group" "storage" {
  name     = "rg-storage-asf"
  location = var.location
  tags     = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_management_lock" "security" {
  name       = "lock-rg-security"
  scope      = azurerm_resource_group.security.id
  lock_level = "CanNotDelete"
  notes      = "Managed by Terraform"
}

resource "azurerm_management_lock" "networking" {
  name       = "lock-rg-networking"
  scope      = azurerm_resource_group.networking.id
  lock_level = "CanNotDelete"
  notes      = "Managed by Terraform"
}

resource "azurerm_management_lock" "storage" {
  name       = "lock-rg-storage"
  scope      = azurerm_resource_group.storage.id
  lock_level = "CanNotDelete"
  notes      = "Managed by Terraform"
}
