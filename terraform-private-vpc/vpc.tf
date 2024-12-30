resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge ( local.common-tags,
    { 
	  tier = "private"
	}
  )
}

resource "aws_subnet" "private_subnet" {
  for_each    = var.subnets
  vpc_id      = aws_vpc.vpc.id
  cidr_block  = each.value["private_cidr"]
  availability_zone = "${each.key}"

  tags = merge ( local.common-tags,
    { 
	  tier = "private"
	}
  )
}

resource "aws_security_group" "allow_all_ipv4" {
  name        = "private_allow_all_ipv4"
  description = "Allow All inbound traffic and all outbound traffic in same VPC"
  vpc_id      = aws_vpc.vpc.id
  
  tags = merge ( local.common-tags,
    { 
	  tier = "private"
	}
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_all_ipv4.id
  referenced_security_group_id = aws_security_group.allow_all_ipv4.id
  ip_protocol       = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_all_ipv4.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  ip_protocol       = -1
}