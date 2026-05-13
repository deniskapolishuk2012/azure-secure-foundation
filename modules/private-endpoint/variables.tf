variable "location" {
  type = string
}

variable "networking_resource_group_name" {
  type = string
}

variable "security_resource_group_name" {
  type = string
}

variable "storage_resource_group_name" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
