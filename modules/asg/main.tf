# 1. Launch Template (defines instance configuration)
resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_group_ids
  key_name = var.key_name != "" ? var.key_name : null

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.name_prefix}-instance"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 2. Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name                = "${var.name_prefix}-asg"
  vpc_zone_identifier = var.vpc_zone_identifier

  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  target_group_arns = var.target_group_arns

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # Tags propagated to instances
  dynamic "tag" {
    for_each = var.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}