resource "azurerm_resource_group" "spoke" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.resource_group_tags
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = var.asset_tags
}

resource "azurerm_subnet" "spoke_subnet" {
  name                 = "${var.vnet_name}-subnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = var.address_space
}

resource "azurerm_route_table" "spoke_rt" {
  name                = var.routing_table_name
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = var.asset_tags

  route {
    name                   = "tohub"
    address_prefix         = var.route_address_prefix
    next_hop_type          = var.next_hop_type
    next_hop_in_ip_address = var.next_hop_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke_rta" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.spoke_subnets[each.key].id
  route_table_id = azurerm_route_table.spoke_rt.id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = var.peering_spoke_to_hub_name
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id // Stellen Sie sicher, dass Sie die richtige ID des Hub VNet haben.
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = var.peering_hub_to_spoke_name
  resource_group_name       = var.hub_resource_group_name		//"rg-network" Ersetzen Sie dies mit dem tatsächlichen Namen der Ressourcengruppe des Hub VNet.
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false // Standardmäßig auf false, da es nur gesetzt wird, wenn Sie die VPN-Gateway des Spoke verwenden möchten.

}
