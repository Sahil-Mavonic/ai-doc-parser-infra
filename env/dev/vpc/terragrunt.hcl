include {
  path = find_in_parent_folders("terragrunt.hcl")
}
terraform {
  source = "../../../modules/vpc"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs = {
  network_name = "doc-parser-vpc"
  subnets = [
    {
      subnet_name   = "private-subnet-1",
      subnet_ip     = "10.0.1.0/24",
      subnet_region = local.common_vars.region,
      tags          = ["private"]
    },
    {
      subnet_name   = "private-subnet-2",
      subnet_ip     = "10.0.2.0/24",
      subnet_region = local.common_vars.region,
      tags          = ["private"]
    }
  ]
}