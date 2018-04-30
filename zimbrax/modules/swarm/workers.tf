resource "aws_placement_group" "worker" {
  name     = "${local.env_prefix_u}placement_group_worker"
  strategy = "spread"
}

resource "aws_launch_configuration" "worker" {
  name          = "${local.env_prefix_u}launch_configuration_worker"
  image_id      = "ami-31c7f654"
  instance_type = "r4.large"
  key_name      = "${local.deployer_key_pair_id}"

  security_groups = [
    "${aws_security_group.swarm.id}",
    "${local.cache_security_group_id}",
    "${local.db_security_group_id}",
    "${local.file_system_security_group_id}",
  ]

  user_data_base64 = "${data.template_cloudinit_config.worker_user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 128
  }
}

resource "aws_autoscaling_group" "workers" {
  name                 = "${local.env_prefix_u}asg_workers"
  launch_configuration = "${aws_launch_configuration.worker.name}"
  placement_group      = "${aws_placement_group.worker.id}"
  vpc_zone_identifier  = ["${local.private_subnet_ids}"]

  desired_capacity = 6
  min_size         = 3
  max_size         = 12

  health_check_grace_period = 1800
  health_check_type         = "EC2"

  tags = [
    {
      key                 = "Name"
      value               = "${local.environment}_instance_worker"
      propagate_at_launch = true
    },
    {
      key                 = "SwarmRole"
      value               = "worker"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${local.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "blockchain"
      propagate_at_launch = true
    },
  ]
}
