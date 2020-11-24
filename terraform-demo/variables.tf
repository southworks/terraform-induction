#####...
#This variales are necessary to login as service principal (to be able to create a role).
#You must create a file named 'terraform.tfvars' with this values.
#format => <variable> = "<value>"
variable "client_secret" {
}

variable "subscription_id" {
}

variable "client_id" {
}

variable "tenant_id" {
}
#####...

variable "function_name" {
  type    = string
  default = "app-demo-vendor-001"
}

variable "rg_name" {
  type    = string
  default = "rg-demo-vendor-001"
}

variable "ams_account" {
  type    = string
  default = "amsdemovendor001"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "tags" {
  default = { project = "demo" }
}
