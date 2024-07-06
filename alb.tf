# Load Balancer
resource "aws_lb" "alb" {
  name               = "alb-2024"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public_primera.id, aws_subnet.public_segunda.id]

  enable_deletion_protection = false

  tags = {
    Name = "alb-2024"
  }
}

# Target Group
resource "aws_lb_target_group" "alb" {
  name     = "target-group-2024"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "my-target-group"
  }
}

# Listener
resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }

  tags = {
    Name = "my-listener"
  }
}

# Adjuntar instancias al grupo objetivo
resource "aws_lb_target_group_attachment" "web_primera" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = aws_instance.web_primera.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_segunda" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = aws_instance.web_segunda.id
  port             = 80
}