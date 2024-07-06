# mysql.tf

# Grupo de seguridad para RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Grupo de seguridad para la instancia RDS MySQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acceso desde cualquier lugar (útil para pruebas)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}

# Grupo de subred para RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.public_primera.id,
    aws_subnet.public_segunda.id
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}

# Instancia de RDS MySQL
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  identifier           = "mysql"
  username             = "admin"
  password             = "admin123"  # Cambia esto a una contraseña segura
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Habilita la asignación de IP pública
  publicly_accessible   = true

  skip_final_snapshot   = true

  tags = {
    Name = "mysql-rds-instance"
  }
}