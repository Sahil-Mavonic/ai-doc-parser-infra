remote_state {
  backend = "gcs"
  config = {
    bucket         = local.common_vars.bucket  # 🚨 REPLACE WITH YOUR BUCKET NAME
    prefix         = "${path_relative_to_include()}/terraform.tfstate"
    project        = local.common_vars.project_id
}
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "google" {
  project = "${local.project_id}"
  region  = "${local.region}"
}
EOF
}

locals {
  # Decode the YAML file to access the environment variable
  common_vars = yamldecode(file("${get_parent_terragrunt_dir()}/common_vars.yaml"))
  project_id = local.common_vars.project_id
  region = local.common_vars.region
}

inputs = {
  project_id = local.project_id
  region     = local.region
}