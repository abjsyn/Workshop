resource_group_name  = "slawekrg022"
location             = "westeurope"

###### GWVPN #####
gwPIP_name           = "Slawek_GW_PIP"
gwName               = "Slawek_GWVPN"

##### Local network GW ###
localGW_name         = "Slawek_LocalGW_VPN"
localGW_address      = "62.62.62.62"
localGW_space        = ["192.168.1.0/24"]
vpnConnection_name   = "Slawek_VPNConnection_DEV"
vnetName             = "slawek_hub_vnet"