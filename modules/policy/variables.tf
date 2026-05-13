variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
