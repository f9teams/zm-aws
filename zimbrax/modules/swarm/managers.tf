resource "aws_instance" "manager" {
  count = "${local.availability_zone_count}"

  ami               = "ami-31c7f654"
  instance_type     = "r4.large"
  key_name          = "${local.deployer_key_pair_id}"
  subnet_id         = "${element(local.private_subnet_ids, count.index)}"
  source_dest_check = false

  vpc_security_group_ids = [
    "${aws_security_group.swarm.id}",
    "${local.cache_security_group_id}",
    "${local.db_security_group_id}",
    "${local.file_system_security_group_id}",
  ]

  user_data = "${data.template_cloudinit_config.manager_user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 128
  }

  tags {
    Name        = "${local.environment}_instance_manager_${count.index}"
    SwarmRole   = "manager"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
