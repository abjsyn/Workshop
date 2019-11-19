variable "resource_group_name" {}
variable "location" {
    default = "westeurope"
}

##### GW VPN ####

variable "gwPIP_name" {}
variable "gwName" {}
variable "localGW_name" {}
variable "localGW_address" {}
variable "localGW_space" {}

###### VPN connection #####

variable "vpnConnection_name" {}

variable "vnetName"{}

