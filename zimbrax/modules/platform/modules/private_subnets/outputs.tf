output "availability_zone_to_private_subnet_id" {
  value = "${zipmap(local.availability_zones, aws_subnet.private.*.id)}"
}

output "private_subnet_id_to_nat_gateway_id" {
  value = "${zipmap(aws_subnet.private.*.id, aws_nat_gateway.egress.*.id)}"
}

output "nat_gateway_id_to_public_subnet_id" {
  value = "${zipmap(aws_nat_gateway.egress.*.id, aws_nat_gateway.egress.*.subnet_id)}"
}
