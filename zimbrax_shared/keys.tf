resource "aws_key_pair" "blockchain_deployer" {
  key_name   = "blockchain_deployer"
  public_key = "${file("${path.module}/deployer_rsa.pub")}"
}

output "blockchain_deployer_key_pair_id" {
  value = "${aws_key_pair.blockchain_deployer.id}"
}
