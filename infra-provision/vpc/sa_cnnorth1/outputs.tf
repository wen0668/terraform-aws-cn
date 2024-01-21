output "aws_region" {
  value = var.aws_region
}

output "vpc_name" {
  description = "The name of the VPC which is also the environment name"
  value       = var.vpc_name
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "cidr_block" {
  value = aws_vpc.my_vpc.cidr_block
}

output "cidr_numeral" {
  value = var.cidr_numeral
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

# Prviate subnets

output "private_subnets_all" {
  value = [aws_subnet.private_subnet.*.id]
}

output "private_subnets" {
  value = slice(
    aws_subnet.private_subnet.*.id,
    0,
    length(split(",", var.availability_zones)),
  )
}

# Public subnets

output "public_subnets" {
  value = slice(
    aws_subnet.public_subnet.*.id,
    0,
    length(split(",", var.availability_zones)),
  )
}