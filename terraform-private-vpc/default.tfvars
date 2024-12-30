# used as service tag
application = "okd-private-vpc"

# aws region
aws_region  = "ca-central-1"

# vpc cidr
vpc_cidr = "10.0.0.0/16"

# use availability zone name as key, define private_cidr for each subnet on this zone
subnets = {
    "ca-central-1a" = { private_cidr: "10.0.128.0/20" }
    "ca-central-1b" = { private_cidr: "10.0.144.0/20" }
    "ca-central-1d" = { private_cidr: "10.0.208.0/20" }
}
  