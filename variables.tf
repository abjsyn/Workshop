
### Spoke ###
variable "vnet_spoke_name" {
}
variable "address_space_spoke" {
    type = "list"
}

variable "dns_servers_spoke" {
    type = "list"
}

variable "subnet1_spoke_name"{
}

variable "spoke_subnet1_preffix" {
}

### HYUB ###

variable "vnet_hub_name" {
}
variable "address_space_hub" {
    type = "list"
}

variable "dns_servers_hub" {
    type = "list"
}

variable "subnet1_hub_name"{
}

variable "hub_subnet1_preffix" {
}

### NSG ###

variable "vnet_spoke_nsg_name" {
  
}

variable "vnet_hub_nsg_name" {
  
}

#### VM ###
variable "username" {
  
}

variable "password" {
  
}

variable "vm1_name" {
  
}
variable "vm2_name" {
  
}