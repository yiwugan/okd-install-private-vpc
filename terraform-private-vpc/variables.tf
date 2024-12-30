variable "aws_region" {
  type    = string
  default = "ca-central-1"
}

variable "application" {
  type    = string
  default = "okd"
}

# VPC Variables

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "subnets" {
  type = map(object({
    private_cidr = string
  }))
  default = {}
}


