resource "aws_ecr_repository" "blockchain" {
  name = "${local.environment}-blockchain"
}
