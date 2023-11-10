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
  remote_virtual_network_id = var.hub_vnet_id // Verwenden Sie die ID des Hub VNet aus der Variable
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
