output "asg_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.my_launch_template.id
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.my_launch_template.latest_version
}