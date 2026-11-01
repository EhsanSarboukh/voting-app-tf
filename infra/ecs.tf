# ECS cluster, environment variables and secrets of the services, the three calls to the service module

data "aws_region" "current" {}

resource "aws_ecs_cluster" "main" {
  name = "${local.name}-cluster"
}

locals {
  db_env = {
    DB_HOST = aws_db_instance.main.address
    DB_PORT = tostring(aws_db_instance.main.port)
    DB_USER = aws_db_instance.main.username
    DB_NAME = aws_db_instance.main.db_name
    DB_SSL  = "true"
  }
  db_secret = {
    DB_PASSWORD = aws_secretsmanager_secret.db.arn
  }
  redis_host = aws_elasticache_cluster.main.cache_nodes[0].address
}

module "vote" {
  source             = "./modules/service"
  name               = "${local.name}-vote"
  image              = "${data.aws_ecr_repository.service["vote"].repository_url}:${var.image_tag}"
  cluster_arn        = aws_ecs_cluster.main.arn
  execution_role_arn = aws_iam_role.exec.arn
  subnet_ids         = [for s in aws_subnet.public : s.id]
  security_group_ids = [aws_security_group.ecs.id]
  desired_count      = var.desired_count
  aws_region         = data.aws_region.current.name

  environment = {
    REDIS_HOST = local.redis_host
    OPTION_A   = var.option_a
    OPTION_B   = var.option_b
  }
  container_port   = 80
  target_group_arn = aws_lb_target_group.vote.arn
  depends_on       = [aws_lb_listener.vote]
}

module "result" {
  source             = "./modules/service"
  name               = "${local.name}-result"
  image              = "${data.aws_ecr_repository.service["result"].repository_url}:${var.image_tag}"
  cluster_arn        = aws_ecs_cluster.main.arn
  execution_role_arn = aws_iam_role.exec.arn
  subnet_ids         = [for s in aws_subnet.public : s.id]
  security_group_ids = [aws_security_group.ecs.id]
  desired_count      = var.desired_count
  aws_region         = data.aws_region.current.name

  environment      = local.db_env
  secrets          = local.db_secret
  container_port   = 80
  target_group_arn = aws_lb_target_group.result.arn
  depends_on       = [aws_lb_listener.result]
}

module "worker" {
  source             = "./modules/service"
  name               = "${local.name}-worker"
  image              = "${data.aws_ecr_repository.service["worker"].repository_url}:${var.image_tag}"
  cluster_arn        = aws_ecs_cluster.main.arn
  execution_role_arn = aws_iam_role.exec.arn
  subnet_ids         = [for s in aws_subnet.public : s.id]
  security_group_ids = [aws_security_group.ecs.id]
  desired_count      = var.desired_count
  aws_region         = data.aws_region.current.name

  environment = merge(local.db_env, { REDIS_HOST = local.redis_host })
  secrets     = local.db_secret
}
