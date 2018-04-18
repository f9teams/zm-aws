resource "aws_key_pair" "blockchain_deployer" {
  key_name   = "blockchain_deployer"
  public_key = "${file("${path.module}/deployer_rsa.pub")}"
}

resource "aws_security_group" "blockchain_app" {
  name   = "blockchain_app"
  vpc_id = "${data.terraform_remote_state.base.blockchain_vpc_id}"

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
    Name      = "${terraform.workspace}_sg_blockchain_app"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

resource "aws_elb" "blockchain_app" {
  name    = "blockchain-app"
  subnets = ["${data.terraform_remote_state.base.blockchain_public_subnet_id}"]

  listener {
    ssl_certificate_id = "${aws_acm_certificate.blockchain_app.id}"
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = 443
    instance_protocol  = "https"
  }

  listener {
    ssl_certificate_id = "${aws_acm_certificate.blockchain_app.id}"
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
    Name      = "${terraform.workspace}_elb_blockchain_app"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

resource "aws_eip" "blockchain_manager1" {
  instance = "${aws_instance.blockchain_manager1.id}"
  vpc      = true

  tags {
    Name      = "${terraform.workspace}_eip_blockchain_manager1"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

resource "aws_instance" "blockchain_manager1" {
  ami                    = "ami-31c7f654"
  instance_type          = "r4.2xlarge"
  key_name               = "${aws_key_pair.blockchain_deployer.id}"
  subnet_id              = "${data.terraform_remote_state.base.blockchain_public_subnet_id}"
  source_dest_check      = false
  vpc_security_group_ids = ["${aws_security_group.blockchain_app.id}"]
  user_data              = "${file("${path.module}/userdata/manager1")}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 256
  }

  tags {
    Name      = "${terraform.workspace}_instance_blockchain_manager1"
    SwarmRole = "manager"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}
