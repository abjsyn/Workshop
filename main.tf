provider "azurerm" {
    version = "=1.31.0"  
}

resource "azurerm_resource_group" "RG" {
    name = "ST-RG1"
    location = "WestEurope"
}


###### VNET and Subnets #######

resource "azurerm_virtual_network" "Vnet_Spoke"{
    name = "${var.vnet_spoke_name}"
    location = "${azurerm_resource_group.RG.location}"
    address_space = "${var.address_space_spoke}"
    dns_servers = "${var.dns_servers_spoke}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    depends_on = ["azurerm_resource_group.RG"]
}

resource "azurerm_subnet" "spoke_subnet"{
    name = "${var.subnet1_spoke_name}"
    resource_group_name = "${azurerm_resource_group.RG.name}"
    virtual_network_name = "${azurerm_virtual_network.Vnet_Spoke.name}"
    address_prefix = "${var.spoke_subnet1_preffix}"
}


