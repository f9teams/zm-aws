resource "aws_security_group" "blockchain_app" {
  name   = "${local.env_prefix_u}blockchain_app"
  vpc_id = "${local.blockchain_vpc_id}"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8443
    to_port          = 8443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags {
    Name        = "${local.environment}_sg_blockchain_app"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_security_group" "blockchain_swarm" {
  name   = "${local.env_prefix_u}blockchain_swarm"
  vpc_id = "${local.blockchain_vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.blockchain_bastion.id}"]
    description     = "allow SSH access from bastion"
  }

  ingress {
    from_port   = 2375
    to_port     = 2377
    protocol    = "tcp"
    self        = true
    description = "2375 unsecure Docker socket. 2376 for tls secure Docker socket. Required for Docker Machine. 2377 for communication between the nodes of a Docker Swarm, only needed on manager nodes."
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self        = true
    description = "TCP 7946 for communication among nodes (container network discovery)"
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self        = true
    description = "UDP 7946 for communication among nodes (container network discovery)"
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
    description = "UDP 4789 for overlay network traffic (container ingress networking)"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags {
    Name        = "${local.environment}_sg_blockchain_swarm"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_elb" "blockchain_app" {
  name    = "${local.env_prefix_d}blockchain-app"
  subnets = ["${local.blockchain_public_subnet_id}"]

  listener {
    ssl_certificate_id = "${local.blockchain_app_certificate_id}"
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = 443
    instance_protocol  = "https"
  }

  listener {
    ssl_certificate_id = "${local.blockchain_app_certificate_id}"
    lb_port            = 8443
    lb_protocol        = "https"
    instance_port      = 8081
    instance_protocol  = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 8
    timeout             = 30
    target              = "HTTPS:443/"
    interval            = 60
  }

  instances                 = ["${aws_instance.blockchain_manager1.id}"]
  cross_zone_load_balancing = true
  connection_draining       = true

  tags {
    Name        = "${local.environment}_elb_blockchain_app"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

data "template_file" "blockchain_manager_cc" {
  template = "${file("${path.module}/cloud-config/manager.cc.tpl")}"

  vars {
    eric_key_pair_public_key = "${local.eric_key_pair_public_key}"
  }
}

data "template_file" "blockchain_manager_mounts_sh" {
  template = "${file("${path.module}/cloud-config/mounts.sh.tpl")}"

  vars {
    blockchain_fs_id = "${local.blockchain_fs_id}"
  }
}

data "template_file" "blockchain_docker_daemon_sh" {
  template = "${file("${path.module}/cloud-config/docker-daemon.sh.tpl")}"
}

data "template_cloudinit_config" "blockchain_manager1_user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "blockchain_manager.cc"
    content      = "${data.template_file.blockchain_manager_cc.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "00_mounts.sh"
    content      = "${data.template_file.blockchain_manager_mounts_sh.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "10_docker-daemon.sh"
    content      = "${data.template_file.blockchain_docker_daemon_sh.rendered}"
  }
}

resource "aws_eip" "blockchain_manager1" {
  instance = "${aws_instance.blockchain_manager1.id}"
  vpc      = true

  tags {
    Name        = "${local.environment}_ip_blockchain_manager1"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_instance" "blockchain_manager1" {
  ami                         = "ami-31c7f654"
  instance_type               = "r4.2xlarge"
  key_name                    = "${local.blockchain_deployer_key_pair_id}"
  subnet_id                   = "${local.blockchain_public_subnet_id}"
  source_dest_check           = false
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.blockchain_app.id}",
    "${aws_security_group.blockchain_swarm.id}",
    "${local.blockchain_fs_sg_id}",
  ]

  user_data = "${data.template_cloudinit_config.blockchain_manager1_user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 256
  }

  tags {
    Name        = "${local.environment}_instance_blockchain_manager1"
    SwarmRole   = "manager"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
