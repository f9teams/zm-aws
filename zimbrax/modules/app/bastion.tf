resource "aws_security_group" "blockchain_bastion" {
  name   = "${local.env_prefix_u}blockchain_bastion"
  vpc_id = "${local.blockchain_vpc_id}"

  ingress {
    from_port        = 22
    to_port          = 22
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
    Name        = "${local.environment}_sg_blockchain_bastion"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

data "template_file" "blockchain_bastion_cc" {
  template = "${file("${path.module}/cloud-config/bastion.cc.tpl")}"

  vars {
    ssh_authorized_keys = "ssh_authorized_keys: ${jsonencode(local.blockchain_user_public_keys)}"
  }
}

data "template_file" "blockchain_bastion_mounts_sh" {
  template = "${file("${path.module}/cloud-config/mounts.sh.tpl")}"

  vars {
    blockchain_fs_id = "${local.blockchain_fs_id}"
  }
}

data "template_file" "blockchain_docker_client_sh" {
  template = "${file("${path.module}/cloud-config/docker-client.sh.tpl")}"

  vars {
    blockchain_swarm_manager_ip = "${aws_instance.blockchain_manager1.private_ip}"
  }
}

data "template_cloudinit_config" "blockchain_bastion_user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "blockchain_bastion.cc"
    content      = "${data.template_file.blockchain_bastion_cc.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "00_mounts.sh"
    content      = "${data.template_file.blockchain_bastion_mounts_sh.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "10_docker-client.sh"
    content      = "${data.template_file.blockchain_docker_client_sh.rendered}"
  }
}

resource "aws_instance" "blockchain_bastion" {
  ami                         = "ami-31c7f654"
  instance_type               = "t2.2xlarge"
  key_name                    = "${local.blockchain_deployer_key_pair_id}"
  subnet_id                   = "${local.blockchain_public_subnet_id}"
  source_dest_check           = false
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.blockchain_bastion.id}",
    "${aws_security_group.blockchain_swarm.id}",
    "${local.blockchain_fs_sg_id}",
  ]

  iam_instance_profile = "${aws_iam_instance_profile.blockchain_bastion.name}"
  user_data            = "${data.template_cloudinit_config.blockchain_bastion_user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 256
  }

  tags {
    Name        = "${local.environment}_instance_blockchain_bastion"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_iam_instance_profile" "blockchain_bastion" {
  name = "${local.env_prefix_u}blockchain_bastion"
  role = "${aws_iam_role.blockchain_bastion.name}"
}

resource "aws_iam_role" "blockchain_bastion" {
  name = "${local.env_prefix_u}blockchain_bastion"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "blockchain_bastion" {
  name       = "${local.env_prefix_u}blockchain_bastion"
  policy_arn = "${aws_iam_policy.blockchain_bastion.arn}"
  roles      = ["${aws_iam_role.blockchain_bastion.name}"]
}

resource "aws_iam_policy" "blockchain_bastion" {
  name = "${local.env_prefix_u}blockchain_bastion"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
