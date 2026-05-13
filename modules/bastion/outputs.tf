output "bastion_name" {
  value = azurerm_bastion_host.this.name
}

output "vm_private_ip" {
  value = azurerm_network_interface.vm.private_ip_address
}
