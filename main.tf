provider "azurerm" {
    version = "=1.31.0"  
}

resource "azurerm_resource_group" "RG1"{
    name = "${var.rg_name}"
    location = "west europe"
}


resource "azurerm_resource_group" "RG" {
    name = "st-rgxxxx"
    location = "WestEurope"
}


###### VNET and Subnets #######

### SPOKE ###

resource "azurerm_virtual_network" "Vnet_Spoke"{
    name = "${var.vnet_spoke_name}"
    location = "${azurerm_resource_group.RG.location}"
    address_space = "${var.address_space_spoke}"
    dns_servers = "${var.dns_servers_spoke}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    depends_on = ["azurerm_resource_group.RG"]
}

resource "azurerm_subnet" "spoke1_subnet"{
    name = "${var.subnet1_spoke_name}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    virtual_network_name = "${azurerm_virtual_network.Vnet_Spoke.name}"
    address_prefix = "${var.spoke_subnet1_preffix}"
}

### HUB ###

resource "azurerm_virtual_network" "Vnet_Hub"{
    name = "${var.vnet_hub_name}"
    location = "${azurerm_resource_group.RG.location}"
    address_space = "${var.address_space_hub}"
    dns_servers = "${var.dns_servers_hub}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    depends_on = ["azurerm_resource_group.RG"]
}

resource "azurerm_subnet" "hub1_subnet"{
    name = "${var.subnet1_hub_name}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    virtual_network_name = "${azurerm_virtual_network.Vnet_Hub.name}"
    address_prefix = "${var.hub_subnet1_preffix}"
}


### NSG ###

resource "azurerm_network_security_group" "NSG_Spoke"{
name = "${var.vnet_spoke_nsg_name}"
resource_group_name = "${azurerm_resource_group.RG.name}"
location = "${azurerm_resource_group.RG.location}"
}

resource "azurerm_network_security_rule" "NSGle_Spoke"{
name                        = "ITA_P_POS_AllowRDP"
priority                    = 100
direction                   = "Inbound"
access                      = "Allow"
protocol                    = "Tcp"
source_port_range           = "3389"
destination_port_range      = "3389"
source_address_prefix       = "*"
destination_address_prefix  = "*"
resource_group_name = "${azurerm_resource_group.RG.name}"
network_security_group_name ="${azurerm_network_security_group.NSG_Spoke.name}"

}

resource "azurerm_network_security_group" "NSG_Hub"{
name = "${var.vnet_hub_nsg_name}"
resource_group_name = "${azurerm_resource_group.RG.name}"
location = "${azurerm_resource_group.RG.location}"
}

resource "azurerm_network_security_rule" "NSGle_Hub"{
name                        = "ITA_P_POS_AllowRDP"
priority                    = 100
direction                   = "Inbound"
access                      = "Allow"
protocol                    = "Tcp"
source_port_range           = "3389"
destination_port_range      = "3389"
source_address_prefix       = "*"
destination_address_prefix  = "*"
resource_group_name = "${azurerm_resource_group.RG.name}"
network_security_group_name ="${azurerm_network_security_group.NSG_Hub.name}"
}

resource "azurerm_subnet_network_security_group_association" "NsgAssociationSpoke1" {
subnet_id = "${azurerm_subnet.spoke1_subnet.id}"
network_security_group_id = "${azurerm_network_security_group.NSG_Spoke.id}"
}

resource "azurerm_subnet_network_security_group_association" "NsgAssociationHub1" {
subnet_id = "${azurerm_subnet.hub1_subnet.id}"
network_security_group_id = "${azurerm_network_security_group.NSG_Hub.id}"
}

### Network peering ###

resource "azurerm_virtual_network_peering" "peerSpokeToHub" {
name = "Spoke_to_HUB_peer" 
resource_group_name = "${azurerm_resource_group.RG.name}"
virtual_network_name = "${azurerm_virtual_network.Vnet_Spoke.name}"
remote_virtual_network_id = "${azurerm_virtual_network.Vnet_Hub.id}"
allow_virtual_network_access = true
allow_gateway_transit        = false
allow_forwarded_traffic      = true
use_remote_gateways          = false

depends_on =["azurerm_virtual_network.Vnet_Spoke","azurerm_virtual_network.Vnet_Hub"]

}

resource "azurerm_virtual_network_peering" "peerHubtoSpoke" {
name = "Hub_to_Spoke_peer" 
resource_group_name = "${azurerm_resource_group.RG.name}"
virtual_network_name = "${azurerm_virtual_network.Vnet_Hub.name}"
remote_virtual_network_id = "${azurerm_virtual_network.Vnet_Spoke.id}"
allow_virtual_network_access = true
allow_gateway_transit        = false
allow_forwarded_traffic      = true
use_remote_gateways          = false

depends_on =["azurerm_virtual_network.Vnet_Spoke","azurerm_virtual_network.Vnet_Hub"]

}


### VPN ####
/*
resource "azurerm_public_ip" "gwPIP"{
    name = "${var.gwPIP_name}"
    resource_group_name = "${var.resource_group_name}"
    location = "${var.location}"
    allocation_method =  "Dynamic"
}

resource "azurerm_virtual_network_gateway" "gwVPN"{
    name = "${var.gwName}"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    type             = "VPN"
    vpn_type         = "RouteBased"
    sku              = "VpnGw1"

    ip_configuration{
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.gwPIP.id}"
        subnet_id                     = "${var.gwSubnetId}"
    }
}

resource "azurerm_local_network_gateway" "localGW"{
    name = "${var.localGW_name}"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    gateway_address = "${var.localGW_address}"
    address_space = "${var.localGW_space}"
    
}

resource "azurerm_virtual_network_gateway_connection" "vpnConnect"{
name = "${var.vpnConnection_name}"
location = "${var.location}"
resource_group_name = "${var.resource_group_name}"
virtual_network_gateway_id = "${azurerm_virtual_network_gateway.gwVPN.id}"
local_network_gateway_id   = "${azurerm_local_network_gateway.localGW.id}"
type = "IPsec"
shared_key = "1223443454365"

}

*/
#### VM ####


resource "azurerm_network_interface" "nic1"{
    
    name = "${var.vm1_name}-nic"
    location = "${azurerm_resource_group.RG.location}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    internal_dns_name_label = "${var.vm1_name}"

    ip_configuration{
        name = "primary"
        subnet_id = "${azurerm_subnet.hub1_subnet.id}"
        private_ip_address_allocation = "Dynamic"
        
    }
}

resource "azurerm_virtual_machine" "VM1"{
    name = "${var.vm1_name}-vm"
    location = "${azurerm_resource_group.RG.location}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    network_interface_ids = ["${azurerm_network_interface.nic1.id}"]
    vm_size = "Standard_DS2_V2"
    delete_os_disk_on_termination = true

    storage_image_reference{
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku      = "2016-Datacenter"
        version   = "latest"
    }

    storage_os_disk {
        name              = "${var.vm1_name}-disk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
      }
    
    os_profile {
    computer_name  = "${var.vm1_name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
    }

    os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
    
    storage_data_disk{
        name = "${var.vm1_name}-datadisk1"
        caching  = "ReadWrite"
        create_option = "Empty"
        disk_size_gb = "128"
        lun = "1"
        managed_disk_type = "StandardSSD_LRS"

    }

}


resource "azurerm_network_interface" "nic2"{
    
    name = "${var.vm2_name}-nic"
    location = "${azurerm_resource_group.RG.location}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    internal_dns_name_label = "${var.vm2_name}"

    ip_configuration{
        name = "primary"
        subnet_id = "${azurerm_subnet.spoke1_subnet.id}"
        private_ip_address_allocation = "Dynamic"
        
    }
}

resource "azurerm_virtual_machine" "VM2"{
    name = "${var.vm2_name}-vm"
    location = "${azurerm_resource_group.RG.location}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    network_interface_ids = ["${azurerm_network_interface.nic2.id}"]
    vm_size = "Standard_DS2_V2"
    delete_os_disk_on_termination = true

    storage_image_reference{
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku      = "2016-Datacenter"
        version   = "latest"
    }

    storage_os_disk {
        name              = "${var.vm2_name}-disk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
      }
    
    os_profile {
    computer_name  = "${var.vm2_name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
    }

    os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
    
    storage_data_disk{
        name = "${var.vm2_name}-datadisk1"
        caching  = "ReadWrite"
        create_option = "Empty"
        disk_size_gb = "128"
        lun = "1"
        managed_disk_type = "StandardSSD_LRS"

    }

}