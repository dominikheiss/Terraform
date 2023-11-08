output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke_vnet.id
}

output "spoke_subnet_ids" {
  value = { for s in azurerm_subnet.spoke_subnets : s.name => s.id }
}

output "spoke_route_table_id" {
  value = azurerm_route_table.spoke_rt.id
}
