resource "azurerm_resource_group" "spoke" {
  provider = azurerm.spoke
  name     = "rg-${var.resource_group_name}" 
  location = var.location
  tags     = var.resource_group_tags
}

resource "azurerm_virtual_network" "spoke_vnet" {
  provider = azurerm.spoke
  name                = "vnet-${var.vnet_name}"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = var.asset_tags
}

resource "azurerm_subnet" "spoke_subnet" {
  provider = azurerm.spoke
  for_each             = var.subnets
  name                 = "snet-${var.vnet_name}"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_route_table" "spoke_rt" {
  provider = azurerm.spoke
  name                = "route-${var.vnet_name}-${var.routing_table_name}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = var.asset_tags

  route {
    name                   = var.route_table_name
    address_prefix         = var.route_address_prefix
    next_hop_type          = var.next_hop_type
    next_hop_in_ip_address = var.next_hop_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke_rta" {
  provider = azurerm.spoke
  for_each = var.subnets

  subnet_id      = azurerm_subnet.spoke_subnet[each.key].id
  route_table_id = azurerm_route_table.spoke_rt.id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  provider = azurerm.spoke
  name                      = "peer-${var.vnet_name}-hub"
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.hub
  name                      = "peer-hub-${var.vnet_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

# -----> LOCKS against accidental deletion <-----

# Lock für die Ressourcengruppe im Spoke
resource "azurerm_management_lock" "spoke_rg_lock" {
  provider   = azurerm.spoke
  name       = "prevent-delete-spoke-rg"
  scope      = azurerm_resource_group.spoke.id
  lock_level = "CanNotDelete"
}

# Lock für das Spoke VNet
resource "azurerm_management_lock" "spoke_vnet_lock" {
  provider   = azurerm.spoke
  name       = "prevent-delete-spoke-vnet"
  scope      = azurerm_virtual_network.spoke_vnet.id
  lock_level = "CanNotDelete"
}

# Lock für jedes Subnet im Spoke VNet
resource "azurerm_management_lock" "spoke_subnet_lock" {
  for_each   = azurerm_subnet.spoke_subnet
  provider   = azurerm.spoke

  name       = "prevent-delete-${each.value.name}"
  scope      = each.value.id
  lock_level = "CanNotDelete"
}

# Lock für die Route Table
resource "azurerm_management_lock" "spoke_rt_lock" {
  provider   = azurerm.spoke
  name       = "prevent-delete-spoke-rt"
  scope      = azurerm_route_table.spoke_rt.id
  lock_level = "CanNotDelete"
}

# Lock für die VNet Peering von Spoke zu Hub
resource "azurerm_management_lock" "spoke_to_hub_peering_lock" {
  provider   = azurerm.spoke
  name       = "prevent-delete-spoke-to-hub-peering"
  scope      = azurerm_virtual_network_peering.spoke_to_hub.id
  lock_level = "CanNotDelete"
}

# Lock für die VNet Peering von Hub zu Spoke (Beachten Sie den anderen Provider, wenn es in einer anderen Subscription ist)
resource "azurerm_management_lock" "hub_to_spoke_peering_lock" {
  provider   = azurerm.hub
  name       = "prevent-delete-hub-to-spoke-peering"
  scope      = azurerm_virtual_network_peering.hub_to_spoke.id
  lock_level = "CanNotDelete"
}

/* Lock für das Hub VNet (Beachten Sie den anderen Provider, wenn es in einer anderen Subscription ist)
resource "azurerm_management_lock" "hub_vnet_lock" {
  provider   = azurerm.hub
  name       = "prevent-delete-hub-vnet"
  scope      = var.hub_vnet_id
  lock_level = "CanNotDelete"
}
*/