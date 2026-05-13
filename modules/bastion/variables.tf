variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "bastion_subnet_id" {
  type = string
}

variable "mgmt_subnet_id" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "common_tags" {
  type = map(string)
}
