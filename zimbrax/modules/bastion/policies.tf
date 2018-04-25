resource "aws_security_group" "bastion" {
  name   = "${local.env_prefix_u}bastion"
  vpc_id = "${local.vpc_id}"

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
    Name        = "${local.environment}_sg_bastion"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_security_group_rule" "ssh_swarm" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion.id}"
  security_group_id        = "${local.swarm_security_group_id}"
  description              = "ssh from bastion to swarm"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.env_prefix_u}bastion"
  role = "${aws_iam_role.bastion.name}"
}

resource "aws_iam_role" "bastion" {
  name = "${local.env_prefix_u}bastion"

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

resource "aws_iam_policy_attachment" "bastion" {
  name       = "${local.env_prefix_u}bastion"
  policy_arn = "${aws_iam_policy.bastion.arn}"
  roles      = ["${aws_iam_role.bastion.name}"]
}

resource "aws_iam_policy" "bastion" {
  name = "${local.env_prefix_u}bastion"

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
