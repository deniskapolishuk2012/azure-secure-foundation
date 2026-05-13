output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "firewall_subnet_id" {
  value = azurerm_subnet.firewall.id
}
