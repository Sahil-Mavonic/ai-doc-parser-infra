variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region where the cluster will be created"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_names" {
  description = "A list of subnet names for node pools"
  type        = list(string)
}

variable "node_machine_type" {
  description = "The machine type for the nodes"
  type        = string
}

variable "node_disk_size" {
  description = "The disk size for each node"
  type        = number
}

variable "node_count_per_pool" {
  description = "The number of nodes in each node pool"
  type        = number
}

variable "environment" {
  description = "The environment label for nodes"
  type        = string
}
