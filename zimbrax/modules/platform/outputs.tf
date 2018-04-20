output "blockchain_vpc_id" {
  value = "${aws_vpc.blockchain.id}"
}

output "blockchain_public_subnet_id" {
  value = "${aws_subnet.blockchain_public.id}"
}
