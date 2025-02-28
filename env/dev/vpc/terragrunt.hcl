include {
  path = find_in_parent_folders("terragrunt.hcl")
}
terraform {
  source = "../../../modules/vpc"
}

inputs = {
  network_name = "doc-parser-vpc"
  subnets = [
    {
      subnet_name   = "private-subnet-1",
      subnet_ip     = "10.0.1.0/24",
      subnet_region = "us-central1",
      tags          = ["private"]
    },
    {
      subnet_name   = "private-subnet-2",
      subnet_ip     = "10.0.2.0/24",
      subnet_region = "us-central1",
      tags          = ["private"]
    }
  ]
}