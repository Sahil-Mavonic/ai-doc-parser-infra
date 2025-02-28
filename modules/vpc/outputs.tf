output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "subnet_ids" {
  value = { for subnet in google_compute_subnetwork.subnets : subnet.name => subnet.id }
}