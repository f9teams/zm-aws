resource "aws_eip" "blockchain_dev" {
  instance = "${aws_instance.blockchain_dev.id}"
  vpc      = true

  tags {
    Name        = "${local.environment}_eip_blockchain_dev"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

output "blockchain_dev_public_ip" {
  value = "${aws_eip.blockchain_dev.public_ip}"
}

resource "aws_instance" "blockchain_dev" {
  ami               = "ami-31c7f654"
  instance_type     = "t2.2xlarge"
  key_name          = "${local.blockchain_deployer_key_pair_id}"
  subnet_id         = "${local.blockchain_public_subnet_id}"
  source_dest_check = false

  vpc_security_group_ids = [
    "${aws_security_group.blockchain_app.id}",
    "${aws_security_group.blockchain_swarm.id}",
  ]

  user_data = "${file("${path.module}/userdata/dev")}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 256
  }

  tags {
    Name        = "${local.environment}_instance_blockchain_dev"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
