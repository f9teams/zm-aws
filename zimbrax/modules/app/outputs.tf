output "blockchain_bastion_public_ip" {
  value = "${aws_instance.blockchain_bastion.public_ip}"
}

output "blockchain_manager1_private_ip" {
  value = "${aws_instance.blockchain_manager1.private_ip}"
}
