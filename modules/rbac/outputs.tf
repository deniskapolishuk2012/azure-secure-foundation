output "security_reader_role_id" {
  value = azurerm_role_definition.security_reader.role_definition_resource_id
}

output "security_operator_role_id" {
  value = azurerm_role_definition.security_operator.role_definition_resource_id
}
