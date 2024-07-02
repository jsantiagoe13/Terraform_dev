resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "description"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

#EC2 en la subred public primera
resource "aws_instance" "web_primera" {
  ami           = "ami-01572eda7c4411960"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_primera.id
  associate_public_ip_address = true
  key_name      = "esp-2024"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "web_instance_primera"
  }
}

#EC2 en la subred public segunda
resource "aws_instance" "web_segunda" {
  ami           = "ami-01572eda7c4411960"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_segunda.id
  associate_public_ip_address = true
  key_name      = "esp-2024"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "web_instance_segunda"
  }
}
