resource "aws_eip" "blockchain_dev" {
  instance = "${aws_instance.blockchain_dev.id}"
  vpc      = true

  tags {
    Name      = "${terraform.workspace}_eip_blockchain_dev"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

resource "aws_instance" "blockchain_dev" {
  ami                    = "ami-31c7f654"
  instance_type          = "t2.2xlarge"
  key_name               = "${aws_key_pair.blockchain_deployer.id}"
  subnet_id              = "${data.terraform_remote_state.base.blockchain_public_subnet_id}"
  source_dest_check      = false
  vpc_security_group_ids = ["${aws_security_group.blockchain_app.id}"]
  user_data              = "${file("${path.module}/userdata/dev")}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 256
  }

  tags {
    Name      = "${terraform.workspace}_instance_blockchain_dev"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}
