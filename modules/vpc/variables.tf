variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Default GCP region"
  type        = string
}

variable "network_name" {
  description = "VPC network name"
  type        = string
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
    tags          = list(string)  # New field
  }))
}