data "aws_security_group" "allow_all_ipv4" {
  name        = "private_allow_all_ipv4"
}

resource "aws_security_group" "jumpbox_allow_ssh" {
  name = "jumpbox_allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id = data.aws_vpc.vpc.id

  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
}        

resource "aws_vpc_security_group_ingress_rule" "jumpbox_allow_ssh" {
  security_group_id = aws_security_group.jumpbox_allow_ssh.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  to_port     = 22
  from_port   = 0
}

resource "aws_vpc_security_group_egress_rule" "jumpbox_allow_ssh" {
  security_group_id = aws_security_group.jumpbox_allow_ssh.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_instance" "jumpbox" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [ 
      data.aws_security_group.allow_all_ipv4.id,
      aws_security_group.jumpbox_allow_ssh.id
    ]
  associate_public_ip_address = true
  subnet_id = aws_subnet.jumpbox_subnet.id
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
	delete_on_termination = true
  }
  
  tags = merge ( local.common-tags,
    { 
	  tier = "jumpbox"
	}
  )
  
  depends_on = [aws_internet_gateway.gateway,local_file.local_key_file]
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "local_key_file" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.local_key_file_name

}


