output "rg_security_name" {
  value = azurerm_resource_group.security.name
}

output "rg_networking_name" {
  value = azurerm_resource_group.networking.name
}

output "rg_storage_name" {
  value = azurerm_resource_group.storage.name
}

output "resource_group_names" {
  value = {
    security   = azurerm_resource_group.security.name
    networking = azurerm_resource_group.networking.name
    storage    = azurerm_resource_group.storage.name
  }
}
