### Spoke ###
vnet_spoke_name = "slawek_spoke_vnet"
address_space_spoke = ["10.110.0.0/16"]
dns_servers_spoke = ["8.8.8.8"]
subnet1_spoke_name = "subnet001"
spoke_subnet1_preffix = "10.110.1.0/24"

### HUB ###

vnet_hub_name = "slawek_hub_vnet"
address_space_hub = ["10.120.0.0/16"]
dns_servers_hub = ["8.8.8.8"]
subnet1_hub_name = "subnet010"
hub_subnet1_preffix = "10.120.1.0/24"

### NSG ###

vnet_spoke_nsg_name = "spoke_NSG_RDP_allow"
vnet_hub_nsg_name = "hub_NSG_RDP_allow"

### VM ###
username = "slawek"
password = "W@rsztaty20192019"
vm1_name = "labVM1"
vm2_name = "labVM2"