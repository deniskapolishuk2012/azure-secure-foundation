variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
