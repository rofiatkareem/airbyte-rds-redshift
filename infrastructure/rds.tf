resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.rds_public_subnet_1.id, aws_subnet.rds_public_subnet_2.id]
}

resource "random_password" "password" {
  length  = 24
  special = false
}

resource "aws_ssm_parameter" "db_admin_password" {
  name  = "/dev/rds/rds_admin_password"
  type  = "String"
  value = random_password.password.result
}

resource "aws_db_instance" "ecommerce_db" {
  allocated_storage         = 10
  db_name                   = "ecommerce"
  engine                    = "postgres"
  engine_version            = "16.6"
  instance_class            = "db.r5.large"
  username                  = data.aws_ssm_parameter.db_admin_username.value
  password                  = aws_ssm_parameter.db_admin_password.value
  parameter_group_name      = "default.postgres16"
  maintenance_window        = "sun:04:30-sun:05:30"
  skip_final_snapshot       = false
  final_snapshot_identifier = "ecommerce-instance-final"
  publicly_accessible       = true
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.rds_SG.id]
} 
