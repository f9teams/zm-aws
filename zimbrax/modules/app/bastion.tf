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
}

data "template_file" "blockchain_bastion_user_data" {
  template = "${file("${path.module}/userdata/bastion.tpl")}"

  vars {
    blockchain_manager1_private_ip = "${aws_instance.blockchain_manager1.private_ip}"
    blockchain_fs_id               = "${local.blockchain_fs_id}"
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
  user_data            = "${data.template_file.blockchain_bastion_user_data.rendered}"

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
