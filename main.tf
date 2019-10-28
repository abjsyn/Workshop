provider "azurerm" {
    version = "=1.31.0"  
}

resource "azurerm_resource_group" "RG" {
    name = "ST-RG1"
    location = "WestEurope"
}


