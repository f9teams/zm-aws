resource "aws_instance" "manager1" {
  ami                         = "ami-31c7f654"
  instance_type               = "r4.2xlarge"
  key_name                    = "${local.deployer_key_pair_id}"
  subnet_id                   = "${local.public_subnet_ids[0]}"
  source_dest_check           = false
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.swarm.id}",
    "${local.file_system_security_group_id}",
  ]

  user_data = "${data.template_cloudinit_config.manager1_user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 256
  }

  tags {
    Name        = "${local.environment}_instance_manager1"
    SwarmRole   = "manager"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
