output "rds_endpoint" {
  value       = try(aws_db_instance.main[0].endpoint, null)
  description = "The endpoint of the primary RDS instance"
}

output "read_replica_endpoint" {
  value       = try(aws_db_instance.replica[0].endpoint, null)
  description = "The endpoint of the read replica (if created)"
}

output "redis_endpoint" {
  value       = try(aws_elasticache_cluster.redis[0].cache_nodes[0].address, null)
  description = "The endpoint of the ElastiCache Redis cluster (if created)"
}
