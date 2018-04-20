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

data "template_file" "blockchain_dev_user_data" {
  template = "${file("${path.module}/userdata/dev.tpl")}"

  vars {
    blockchain_manager1_private_ip = "${aws_instance.blockchain_manager1.private_ip}"
  }
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

  iam_instance_profile = "${aws_iam_instance_profile.blockchain_dev.name}"
  user_data            = "${data.template_file.blockchain_dev_user_data.rendered}"

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

resource "aws_iam_instance_profile" "blockchain_dev" {
  name = "${local.environment}_blockchain_dev"
  role = "${aws_iam_role.blockchain_dev.name}"
}

resource "aws_iam_role" "blockchain_dev" {
  name = "${local.environment}_blockchain_dev"

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

resource "aws_iam_policy_attachment" "blockchain_dev" {
  name       = "${local.environment}_blockchain_dev"
  policy_arn = "${aws_iam_policy.blockchain_dev.arn}"
  roles      = ["${aws_iam_role.blockchain_dev.name}"]
}

resource "aws_iam_policy" "blockchain_dev" {
  name = "${local.environment}_blockchain_dev"

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
