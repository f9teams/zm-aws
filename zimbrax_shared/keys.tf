resource "aws_key_pair" "blockchain_deployer" {
  key_name   = "blockchain_deployer"
  public_key = "${file("${path.module}/deployer_rsa.pub")}"
}

resource "aws_key_pair" "eric" {
  key_name   = "eric"
  public_key = "${file("${path.module}/eric.pub")}"
}
