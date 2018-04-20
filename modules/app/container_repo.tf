resource "aws_ecr_repository" "blockchain" {
  count = "${length(local.containers)}"
  name  = "${local.env_prefix_d}${local.containers[count.index]}"
}
