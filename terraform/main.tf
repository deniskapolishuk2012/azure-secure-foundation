module "governance" {
  source = "../modules/governance"

  location    = var.location
  common_tags = local.common_tags
}

module "policy" {
  source = "../modules/policy"

  subscription_id = var.subscription_id
  common_tags     = local.common_tags

  depends_on = [module.governance]
}

module "networking" {
  source = "../modules/networking"

  location            = var.location
  resource_group_name = module.governance.rg_networking_name
  common_tags         = local.common_tags

  depends_on = [module.governance]
}

module "key_vault" {
  source = "../modules/key-vault"

  location            = var.location
  resource_group_name = module.governance.rg_security_name
  tenant_id           = var.tenant_id
  common_tags         = local.common_tags

  depends_on = [module.governance]
}

module "rbac" {
  source = "../modules/rbac"

  subscription_id = var.subscription_id
  common_tags     = local.common_tags

  depends_on = [module.governance]
}

module "storage_secure" {
  source = "../modules/storage-secure"

  location            = var.location
  resource_group_name = module.governance.rg_storage_name
  common_tags         = local.common_tags

  depends_on = [module.governance]
}

module "purview" {
  source = "../modules/purview"

  location            = var.location
  resource_group_name = module.governance.rg_security_name
  common_tags         = local.common_tags

  depends_on = [module.governance]
}

module "private_endpoint" {
  source = "../modules/private-endpoint"

  location                       = var.location
  networking_resource_group_name = module.governance.rg_networking_name
  security_resource_group_name   = module.governance.rg_security_name
  storage_resource_group_name    = module.governance.rg_storage_name
  vnet_id                        = module.networking.hub_vnet_id
  subnet_id                      = module.networking.mgmt_subnet_id
  key_vault_id                   = module.key_vault.key_vault_id
  storage_account_id             = module.storage_secure.storage_account_id
  common_tags                    = local.common_tags

  depends_on = [module.networking, module.key_vault, module.storage_secure]
}

module "conditional_access" {
  source = "../modules/conditional-access"

  excluded_user_id = var.excluded_user_id
}

module "monitoring" {
  source = "../modules/monitoring"

  location            = var.monitoring_location
  resource_group_name = module.governance.rg_security_name
  key_vault_id        = module.key_vault.key_vault_id
  storage_account_id  = module.storage_secure.storage_account_id
  common_tags         = local.common_tags

  depends_on = [module.key_vault, module.storage_secure]
}

module "sentinel" {
  source = "../modules/sentinel"

  log_analytics_workspace_id = module.monitoring.law_id

  depends_on = [module.monitoring]
}

module "managed_identity" {
  source = "../modules/managed-identity"

  location            = var.location
  resource_group_name = module.governance.rg_security_name
  key_vault_id        = module.key_vault.key_vault_id
  common_tags         = local.common_tags

  depends_on = [module.key_vault]
}

# Deploy → record video → destroy:
# terraform apply -target=module.bastion -target=module.firewall -var="vm_admin_password=TempPass123!"
# terraform destroy -target=module.bastion -target=module.firewall -var="vm_admin_password=TempPass123!"
module "bastion" {
  source = "../modules/bastion"

  location            = var.location
  resource_group_name = module.governance.rg_networking_name
  bastion_subnet_id   = module.networking.bastion_subnet_id
  mgmt_subnet_id      = module.networking.mgmt_subnet_id
  admin_password      = var.vm_admin_password
  common_tags         = local.common_tags

  depends_on = [module.networking]
}

module "firewall" {
  source = "../modules/firewall"

  location            = var.location
  resource_group_name = module.governance.rg_networking_name
  firewall_subnet_id  = module.networking.firewall_subnet_id
  mgmt_subnet_id      = module.networking.mgmt_subnet_id
  common_tags         = local.common_tags

  depends_on = [module.networking]
}
