
# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable Postgres/PGAdmin access on port 5432"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostGres/PGAdmin access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.cicd_workflow.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database security group"
  }
}

# create subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "database_subnet"
  subnet_ids  = [aws_subnet.subnet_public1.id, aws_subnet.subnet_public2.id]
  description = "subnet for databse instance"

  tags = {
    Name = "database-subnet"
  }
}

# create the postgres rds instance
resource "aws_db_instance" "db_instance" {
  engine                 = var.DB-engine
  engine_version         = var.engine_version
  multi_az               = false
  identifier             = var.identifier
  username               = "project"
  password               = "password123"
  db_name                = "CICD_Database"
  instance_class         = var.DB-instance_class
  allocated_storage      = 200
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  availability_zone      = data.aws_availability_zones.available_zones.names[0]
  publicly_accessible    = true
  skip_final_snapshot    = true
}

output "security_group_id" {
  value = aws_security_group.cicd_workflow.id
}
output "db_instance_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}




























# # create the subnet group for the rds instance
# resource "aws_db_subnet_group" "database_subnet_group" {
#   name        = "database_subnet"
#   subnet_ids  = [aws_default_subnet.subnet_az1.id, aws_default_subnet.subnet_az2.id]
#   description = "subnet for databse instance"

#   tags = {
#     Name = "database-subnet"
#   }
# }

# # create the postgres rds instance
# resource "aws_db_instance" "db_instance" {
#   engine                 = var.DB-engine
#   engine_version         = var.engine_version
#   multi_az               = false
#   identifier             = var.identifier
#   username               = var.DB-username
#   password               = var.DB-password
#   db_name                = var.DB-name
#   instance_class         = var.DB-instance_class
#   allocated_storage      = 200
#   db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
#   vpc_security_group_ids = [aws_security_group.database_security_group.id]
#   availability_zone      = data.aws_availability_zones.available_zones.names[0]
#   publicly_accessible    = true
#   skip_final_snapshot    = true
# }