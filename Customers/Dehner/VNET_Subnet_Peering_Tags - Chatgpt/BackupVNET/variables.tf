variable "location" {
  description = "The Azure Region where all resources in this configuration should be created."
  default     = "West Europe"
}

variable "subscription_id" {
  description = "Definition of proper Subscription ID"
  default     = "08070a81-7b5c-4b3e-b50a-c43c8047e8f9"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default = "rg-network"
}

variable "vnet_name" {
  description = "Name of the VNet"
  default = "backup"
}

variable "address_space" {
  description = "Address space for the VNet and its subnets"
  default     = ["10.180.24.0/24"]
  type        = list(string)
}

variable "hub_resource_group_name" {
  description = "The name of the resource group for the Hub VNet"
  default     = "rg-network"
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  default     = "vnet-hub"
}

variable "subnets" {
  description = "Map of subnets with properties"
  type = map(object({
    address_prefixes = list(string)
    // Weitere Subnetz-Eigenschaften können hier hinzugefügt werden
  }))
  default = {
    "snet-backup" = {
      address_prefixes = ["10.180.24.0/24"]
      // Setzen Sie weitere Standardwerte für zusätzliche Eigenschaften hier
    }
    // Fügen Sie weitere Subnetze nach Bedarf hinzu
  }
}

variable "routing_table_name" {
  description = "Name of the routing table"
  default = "route-backup-to-hub"
}

variable "route_table_name" {
  description = "The name of the route table"
  default     = "tohub"
}

variable "route_address_prefix" {
  description = "The destination CIDR to which the route applies"
  default     = "0.0.0.0/0"
}

variable "next_hop_type" {
  description = "The type of Azure hop the packet should be sent to"
  default     = "VirtualAppliance"
}

variable "next_hop_ip_address" {
  description = "The IP address packets should be forwarded to"
  default     = "10.180.0.68"
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub VNet"
  default     = "/subscriptions/e635aa2a-2f4a-432e-8d5a-07f9ddce0808/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-hub"
  type        = string
}

variable "peering_spoke_to_hub_name" {
  description = "Name for the peering from the Spoke VNet to the Hub VNet"
  default     = "peer-backup-hub" // Setzen Sie `yyy` durch einen Wert, der für Ihr Setup repräsentativ ist.
}

variable "peering_hub_to_spoke_name" {
  description = "Name for the peering from the Hub VNet to the Spoke VNet"
  default     = "peer-hub-backup" // Setzen Sie `xxx` durch einen Wert, der für Ihr Setup repräsentativ ist.
}

variable "resource_group_tags" {
  description = "Tags for the resource group"
  default = {
    Environment       = "IT"
    Owner             = "ITSM"
    Project           = "Infrastructure"
    CostCenter        = "ITSM"
    OperatingTeamOS   = "ITSM"
    OperatingTeamApp  = "ITSM"
  }
}

variable "asset_tags" {
  description = "Tags for all assets except the resource group"
  default = {
    CreatedBy   = "admHeiss"
    Workload    = "VNET"
    Description = "Virtual Network"
  }
}
