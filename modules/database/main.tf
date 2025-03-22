resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  count                   = var.primary_rds_instance ? 1 : 0
  allocated_storage       = 20
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "mypassword"
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [var.security_group]
  skip_final_snapshot     = true
  backup_retention_period = 1 # ✅ Enable automated backups!

  tags = {
    Name = "primary-db-instance"
  }
}

resource "aws_db_instance" "replica" {
  count                   = var.enable_read_replica ? 1 : 0
  replicate_source_db  = aws_db_instance.main[0].arn
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [var.security_group]
  skip_final_snapshot     = true

  tags = {
    Name = "read-replica"
  }
}

resource "aws_elasticache_subnet_group" "cache" {
  count      = var.enable_cache_cluster ? 1 : 0
  name       = "cache-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "cache-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis" {
  count                 = var.enable_cache_cluster ? 1 : 0
  cluster_id            = "redis-cluster"
  engine                = "redis"
  node_type             = "cache.t2.micro"
  num_cache_nodes       = 1
  parameter_group_name = "default.redis7"
  subnet_group_name     = aws_elasticache_subnet_group.cache[0].name
  security_group_ids    = [var.security_group]

  tags = {
    Name = "redis-cache"
  }
}
