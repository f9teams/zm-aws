resource "aws_key_pair" "blockchain_deployer" {
  key_name   = "blockchain_deployer"
  public_key = "${file("${path.module}/ssh/deployer.pub")}"
}

resource "aws_key_pair" "blockchain_user" {
  count      = "${length(local.user_keys)}"
  key_name   = "blockchain_user_${local.user_keys[count.index]}"
  public_key = "${file("${path.module}/ssh/${local.user_keys[count.index]}.pub")}"
}
