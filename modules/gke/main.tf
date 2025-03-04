terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "gcs" {}
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id
  
  network  = var.network_name
  subnetwork = var.subnet_names[0] # Use the first subnet for control plane
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  initial_node_count       = 1
  remove_default_node_pool = true
  #networking_mode          = "VPC_NATIVE"

  # ip_allocation_policy {
  #   cluster_secondary_range_name  = "pod-range"
  #   services_secondary_range_name = "service-range"
  # }
}

resource "google_container_node_pool" "node_pools" {
  for_each = toset(var.subnet_names)

  name     = "np-${var.cluster_name}"
  cluster  = google_container_cluster.primary.id
  location = var.region
  project  = var.project_id

  node_count = 2# Force only 1 node per pool

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    disk_type    = "pd-standard"
    preemptible  = true

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      environment = var.environment
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

