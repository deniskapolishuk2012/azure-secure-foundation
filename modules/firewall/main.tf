resource "azurerm_public_ip" "firewall" {
  name                = "pip-firewall-asf"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_firewall_policy" "this" {
  name                = "fwpolicy-asf"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_firewall" "this" {
  name                = "fw-asf"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id
  tags                = var.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# Allow VM subnet to reach Windows Update and Microsoft services only
resource "azurerm_firewall_policy_rule_collection_group" "demo" {
  name               = "rcg-demo-asf"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 100

  application_rule_collection {
    name     = "allow-microsoft-services"
    priority = 100
    action   = "Allow"

    rule {
      name = "allow-windows-update"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.1.0/24"]
      destination_fqdns = ["*.microsoft.com", "*.windowsupdate.com", "*.ubuntu.com"]
    }
  }

  network_rule_collection {
    name     = "deny-all-outbound"
    priority = 200
    action   = "Deny"

    rule {
      name                  = "deny-all"
      protocols             = ["Any"]
      source_addresses      = ["10.0.1.0/24"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}

# Route all traffic from mgmt subnet through the firewall
resource "azurerm_route_table" "mgmt" {
  name                = "rt-mgmt-asf"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

resource "azurerm_route" "default_to_firewall" {
  name                   = "default-to-firewall"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.mgmt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "mgmt" {
  subnet_id      = var.mgmt_subnet_id
  route_table_id = azurerm_route_table.mgmt.id
}
