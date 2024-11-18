terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  subscription_id = "85f15670-31f7-471c-b42b-ee05b30816ed"
}