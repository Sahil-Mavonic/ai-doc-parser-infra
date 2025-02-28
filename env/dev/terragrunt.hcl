remote_state {
  backend = "gcs"
  config = {
    bucket         = "mybucket996"  # 🚨 REPLACE WITH YOUR BUCKET NAME
    prefix         = "${path_relative_to_include()}/terraform.tfstate"
    project        = "sahil-devops"
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
  project_id = "sahil-devops"  # 🚨 REPLACE WITH YOUR PROJECT ID
  region     = "us-central1"
}

inputs = {
  project_id = local.project_id
  region     = local.region
}