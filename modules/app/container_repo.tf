resource "aws_ecr_repository" "blockchain" {
  count = "${length(local.containers)}"
  name  = "${local.environment}-${local.containers[count.index]}"
}
