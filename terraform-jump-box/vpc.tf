data "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

data "aws_subnets" "private_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    tier = "private"
  }  
}



resource "aws_internet_gateway" "gateway" {
  vpc_id = data.aws_vpc.vpc.id

  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
}

resource "aws_subnet" "jumpbox_subnet" {
  vpc_id      = data.aws_vpc.vpc.id
  cidr_block  = var.jumpbox_cidr
  availability_zone = var.jumpbox_availability_zone
  map_public_ip_on_launch  = true

  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_route_table" "jumpbox_route" {
  vpc_id            = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
}

resource "aws_route_table_association" "jumpbox_route_asso" {
  subnet_id      = aws_subnet.jumpbox_subnet.id
  route_table_id = aws_route_table.jumpbox_route.id
}

resource "aws_eip" "nat_ip" {
  domain = "vpc"
  
  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.jumpbox_subnet.id

  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
}

resource "aws_route_table" "private_route" {
  vpc_id            = data.aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway.id
  }

  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
}

resource "aws_route_table_association" "private_route_asso" {
  for_each       = toset(data.aws_subnets.private_subnet.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.private_route.id
}

