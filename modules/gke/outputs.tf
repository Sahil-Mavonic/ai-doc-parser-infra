output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "node_pools" {
  description = "The names of the created node pools"
  value       = [for np in google_container_node_pool.node_pools : np.name]
}

output "subnets_used" {
  description = "List of subnets used for the node pools"
  value       = var.subnet_names
}

output "network_name" {
  description = "The VPC network used by the cluster"
  value       = google_container_cluster.primary.network
}
