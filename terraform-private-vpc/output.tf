output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "security_group_id" {
  value = aws_security_group.allow_all_ipv4.id
}

output "aws_subnet_ids" {
  value = [
    for private_subnet in aws_subnet.private_subnet : private_subnet.id
  ]
}
