resource "aws_instance" "bastion" {
  ami                         = "ami-31c7f654"
  instance_type               = "t2.2xlarge"
  key_name                    = "${local.deployer_key_pair_id}"
  subnet_id                   = "${local.public_subnet_id}"
  source_dest_check           = false
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
    "${local.cache_security_group_id}",
    "${local.db_security_group_id}",
    "${local.file_system_security_group_id}",
    "${local.swarm_security_group_id}",
  ]

  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"
  user_data            = "${data.template_cloudinit_config.user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 128
  }

  tags {
    Name        = "${local.environment}_instance_bastion"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
