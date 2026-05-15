variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
  default     = ""
}

variable "location" {
  description = "Primary Azure region"
  type        = string
  default     = "israelcentral"
}

variable "monitoring_location" {
  description = "Region for Log Analytics workspace and Sentinel (must support Defender XDR unified portal)"
  type        = string
  default     = "westeurope"
}
variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "lab"
}

variable "project" {
  description = "Project tag value"
  type        = string
  default     = "azure-secure-foundation"
}

variable "owner" {
  description = "Owner tag value"
  type        = string
  default     = "Denis"
}

variable "excluded_user_id" {
  description = "Object ID of the user excluded from Conditional Access policies"
  type        = string
  default     = ""
}

variable "vm_admin_password" {
  description = "Admin password for the demo VM (used with Bastion module)"
  type        = string
  sensitive   = true
  default     = null
}
