# All the outputs (O2)

output "vote_url" {
  description = "Public URL of the vote page"
  value       = "http://${aws_lb.main.dns_name}"
}

output "result_url" {
  description = "Public URL of the result page"
  value       = "http://${aws_lb.main.dns_name}:8080"
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "db_endpoint" {
  value = aws_db_instance.main.address
}
