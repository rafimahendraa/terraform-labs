output "vpc_id" {
  description = "VPC ID."
  value       = try(aws_vpc.this[0].id, null)
}

output "internet_gateway_id" {
  description = "Internet Gateway ID."
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "public_subnet_ids" {
  description = "Public subnet IDs by AZ."
  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs by AZ."
  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs."
  value = {
    for key, nat in aws_nat_gateway.this :
    key => nat.id
  }
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = try(aws_route_table.public[0].id, null)
}

output "private_route_table_ids" {
  description = "Private route table IDs."
  value = {
    for key, route_table in aws_route_table.private :
    key => route_table.id
  }
}
