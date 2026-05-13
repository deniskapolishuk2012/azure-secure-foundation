variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}

variable "mgmt_subnet_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
