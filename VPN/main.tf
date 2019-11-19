provider "azurerm" {
     version         = "=1.31.0"
}

data "azurerm_subnet" "gwSubnet"{
    name = "GatewaySubnet"
    virtual_network_name = "${var.vnetName}"
    resource_group_name  = "${var.resource_group_name}"
}

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
        subnet_id                     = "${data.azurerm_subnet.gwSubnet.id}"
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
shared_key = "qwertyuiop123456"

}

