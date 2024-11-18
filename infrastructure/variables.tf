variable "rgName" {
  
}

variable "location" {
  type = string
  default = "West Europe"
}

variable "storageaccount" {
  type = string
  default = "st-bh-tfstate"
}
variable "containername" {
  type = string 
  default = "con-bh-tfstate"
}

variable "serviceconnection" {
    type = string
    default = "az-deployment"
  
}


# AKS cluster and Node_pool variables


variable "clusterName" {
  
}


# Vnet and Subnet variables


variable "env" {
  
}

variable "kv-name" {
  
}

variable "ssh_key_name" {
  
}

variable "acrName" {
  
}
