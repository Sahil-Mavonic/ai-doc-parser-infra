terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "gcs" {}
}

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each      = { for subnet in var.subnets : subnet.subnet_name => subnet }
  name          = each.value.subnet_name
  ip_cidr_range = each.value.subnet_ip
  region        = each.value.subnet_region
  network       = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Block all external traffic to private subnets
resource "google_compute_firewall" "deny_all_ingress" {
  name    = "${var.network_name}-deny-all-ingress"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  
  deny {
    protocol = "all"
  }

  target_tags = ["private"]
}

# Allow only essential internal communication
resource "google_compute_firewall" "allow_essential_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc.name

  source_ranges = [for subnet in var.subnets : subnet.subnet_ip]
  
  allow {
    protocol = "tcp"
    ports    = ["443", "10250"]  # Kubernetes requirements
  }

  allow {
    protocol = "icmp"  # Optional: Remove if not needed
  }

  target_tags = ["private"]
}

resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}