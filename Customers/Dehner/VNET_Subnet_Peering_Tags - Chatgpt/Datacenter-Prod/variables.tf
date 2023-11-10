variable "subscription_id" {
  description = "Definition of proper Subscription ID"
  default     = "f96bb086-c28f-40a3-88a8-89de63160a72"    # Bitte je nach Subscription ändern
}

variable "vnet_name" {
  description = "Name of the VNet"
  default = "datacenter-prod"   # Bitte je nach Subscription ändern
}

variable "address_space" {
  description = "Address space for the VNet and its subnets"
  default     = ["10.180.18.0/24"]
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets with properties"
  type = map(object({
    address_prefixes = list(string)
    # Weitere Subnetz-Eigenschaften können hier hinzugefügt werden
  }))
  default = {
    "snet" = {
      address_prefixes = ["10.180.18.0/24"]   # Bitte je nach Subscription ändern

      # Setzen Sie weitere Standardwerte für zusätzliche Eigenschaften hier
    }
    # Fügen Sie weitere Subnetze nach Bedarf hinzu
  }
}

variable "resource_group_tags" {
  description = "Tags for the resource group"
  default = {
    Environment       = "Prod"
    Owner             = "Datacenter"
    Project           = "Landingzone"
    CostCenter        = "515140"
    OperatingTeamOS   = "Datacenter"
    OperatingTeamApp  = "Datacenter"
    Criticality       = "Mission-Critical"
#    DataClassification = "General"
  }
}

variable "asset_tags" {
  description = "Tags for all assets except the resource group"
  default = {
    CreatedBy   = "admHeiss"
    Workload    = "Landingzone"
    Description = "Components of the Hub & Spoke Landingzone"
  }
}









# -----> HARD CODED VARIABLES - DO NOT CHANGE <-----

variable "location" {
  description = "The Azure Region where all resources in this configuration should be created."
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default = "network"
}

variable "hub_subscription_id" {
  description = "Definition of HUB Subscription ID"
  default     = "e635aa2a-2f4a-432e-8d5a-07f9ddce0808"  # Hardcoded - does not change!
}

variable "hub_resource_group_name" {
  description = "The name of the resource group for the Hub VNet"
  default     = "rg-network" # Hardcoded - does not change!
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  default     = "vnet-hub" # Hardcoded - does not change!
}

variable "route_table_name" {
  description = "The name of the route table"
  default     = "to-hub"  # Hardcoded - does not change!
}

variable "route_address_prefix" {
  description = "The destination CIDR to which the route applies"
  default     = "0.0.0.0/0" #  Hardcoded - does not change!
}

variable "next_hop_type" {
  description = "The type of Azure hop the packet should be sent to"
  default     = "VirtualAppliance"  # Hardcoded - does not change!
}

variable "next_hop_ip_address" {
  description = "The IP address packets should be forwarded to"
  default     = "10.180.0.68" # Hardcoded - does not change!
}

variable "routing_table_name" {
  description = "Name of the routing table"
  default = "to-hub"  # Hardcoded - does not change!
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub VNet"
  default     = "/subscriptions/e635aa2a-2f4a-432e-8d5a-07f9ddce0808/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-hub"  // Hardcoded - does not change!
  type        = string
}

