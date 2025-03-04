include {
  path = find_in_parent_folders("terragrunt.hcl")
}
terraform {
  source = "../../../modules/gke"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}
inputs = {
  project_id          = local.common_vars.project_id
  region              = local.common_vars.region
  cluster_name        = "doc-parser-cluster"
  network_name        = "doc-parser-vpc"
  subnet_names        = [ #put your subnet names 
 
  ]
  node_machine_type   = "e2-medium"
  node_disk_size      = 50
  node_count_per_pool = 1
  environment         = "dev"
}