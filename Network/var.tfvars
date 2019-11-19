
rg_name = "slawekrg022"
location = "westeurope"

### Spoke ###
vnet_spoke_name = "slawek_spoke_vnet"
address_space_spoke = ["10.130.0.0/16"]
dns_servers_spoke = ["8.8.8.8"]
subnet1_spoke_name = "subnet001"
spoke_subnet1_preffix = "10.130.1.0/24"

### HUB ###

vnet_hub_name = "slawek_hub_vnet"
address_space_hub = ["10.140.0.0/16"]
dns_servers_hub = ["8.8.8.8"]
subnet1_hub_name = "subnet010"
hub_subnet1_preffix = "10.140.1.0/24"
hub_gatewaysubnet_preffix = "10.140.2.0/24"
gatewaySubnetName = "GatewaySubnet"
### NSG ###

vnet_spoke_nsg_name = "spoke_NSG_RDP_allow"
vnet_hub_nsg_name = "hub_NSG_RDP_allow"

### VM ###
username = "slawek"
password = "W@rsztaty20192019"
vm1_name = "labVM1"
vm2_name = "labVM2"