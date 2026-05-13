resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.networking_resource_group_name
  tags                = var.common_tags
}

resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.networking_resource_group_name
  tags                = var.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "link-kv-asf"
  resource_group_name   = var.networking_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = var.vnet_id
  tags                  = var.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "link-storage-asf"
  resource_group_name   = var.networking_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = var.vnet_id
  tags                  = var.common_tags
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-kv-asf"
  location            = var.location
  resource_group_name = var.security_resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.common_tags

  private_service_connection {
    name                           = "psc-kv-asf"
    private_connection_resource_id = var.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dzg-kv-asf"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }
}

resource "azurerm_private_endpoint" "storage" {
  name                = "pe-storage-asf"
  location            = var.location
  resource_group_name = var.storage_resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.common_tags

  private_service_connection {
    name                           = "psc-storage-asf"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dzg-storage-asf"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }
}
