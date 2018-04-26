output "availability_zone_to_public_subnet_id" {
  value = "${zipmap(local.availability_zones, aws_subnet.public.*.id)}"
}
