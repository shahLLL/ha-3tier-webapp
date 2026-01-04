# 1. Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection
  enable_cross_zone_load_balancing = true

  tags = merge(
    var.common_tags,
    {
      Name        = var.name
      Environment = var.environment
    }
  )
}

# 2. Target Group (for HTTP/HTTPS traffic)
resource "aws_lb_target_group" "app_lb_tg" {
  name     = "${var.name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "instance"  # or "ip" if using ECS/Fargate

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-tg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# 3. HTTP Listener (port 80)
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-http-listener"
    }
  )
}
