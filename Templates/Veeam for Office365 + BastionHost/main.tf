provider "azurerm" {
  features {}
}

##### Create a resource group

resource "azurerm_resource_group" "rg" {
  name     					= "${var.prefix}-RG1"
  location 					= var.location
}

##### Use existing resource group 
#data "azurerm_resource_group" "gepgroup1" {
#    name     = "NexxeNeo4j-rg"
#}

##### Create the VNET

resource "azurerm_virtual_network" "vnet" {
  name                	= "${var.prefix}-VNET1"
  address_space 		= ["10.100.0.0/16"]
  resource_group_name 	= azurerm_resource_group.rg.name
  location 				= azurerm_resource_group.rg.location
}

##### Create a subnet for Azure Servers

resource "azurerm_subnet" "Server" {
  name 					= "Server" 
  address_prefixes 		= ["10.100.1.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
}

##### Create a subnet for Windows Virtual Desktops

resource "azurerm_subnet" "WVD" {
  name 					= "WVD" 
  address_prefixes 		= ["10.100.10.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
}

##### Create a subnet for Azure Bastion Host

resource "azurerm_subnet" "AzureBastionSubnet" {
  name 					= "AzureBastionSubnet" 
  address_prefixes 		= ["10.100.254.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
}

##### Create a subnet for VPN Gateway

resource "azurerm_subnet" "Gateway" {
  name 					= "Gateway" 
  address_prefixes 		= ["10.100.255.0/24"]
  virtual_network_name 	= azurerm_virtual_network.vnet.name
  resource_group_name 	= azurerm_resource_group.rg.name
}

##### Create a Network Card

resource "azurerm_network_interface" "nic-veeam" {
  name                = "${var.prefix}-VeeamNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.Server.id
    private_ip_address_allocation = "Dynamic"
  }
}

##### Create a VM

resource "azurerm_virtual_machine" "vm-veeam" {
  name                  = "${var.prefix}-VeeamO365"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic-veeam.id]
  vm_size               = "Standard_E2as_v4"

##### Marketplace image details again

	plan {
	name= "veeamoffice365backup"
	publisher= "veeam"
	product= "office365backup"
  }
	
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

##### Select the IMAGE from the marketplace (az vm image list --output table --all --publisher Veeam)

  storage_image_reference {
    publisher = "veeam"
    offer     = "office365backup"
    sku       = "veeamoffice365backup"
    version   = "4.0.2"
  }
  
##### VM Disk preferences
  
  storage_os_disk {
    name              = "veeamo365disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  
##### Password
  
  os_profile {
    computer_name  = "VeeamO365"
    admin_username = "Bechtle-adm"
    admin_password = "Bechtle123!"
  }
  os_profile_windows_config {
    enable_automatic_upgrades 	= false
	provision_vm_agent 			= true
	timezone					= "W. Europe Standard Time"
  }
  tags = {
    environment = "staging"
  }
}

##### Create Azure Bastion Host

resource "azurerm_public_ip" "bastion-ip" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

##### Config Bastion Host

resource "azurerm_bastion_host" "bastionhost" {
  name                = "Veeam Bastion Host"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-ip.id
  }
}

##### Create Veeam APP for Modern Authentication

resource "azuread_application" "veeamapp" {
  name = "VeeamAPP"
  required_resource_access {
    # MicrosoftGraph API
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    # APPLICATION PERMISSIONS: "Read directory data":
    # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }
    # APPLICATION PERMISSIONS: "Read group data":
    # 5b567255-7703-4780-807c-7be8301ae99b
    resource_access {
      id   = "5b567255-7703-4780-807c-7be8301ae99b"
      type = "Role"
    }	
  }
}


