# Data sources that read the three ECR repositories (created by the bootstrap)

data "aws_ecr_repository" "service" {
  for_each = toset(local.services)
  name     = "${var.name_prefix}-${each.key}"
}
