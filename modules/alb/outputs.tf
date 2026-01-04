output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app_lb.arn
}

output "dns_name" {
  description = "DNS name of the ALB (e.g. for DNS records)"
  value       = aws_lb.app_lb.dns_name
}

output "zone_id" {
  description = "Canonical hosted zone ID for Route 53 alias records"
  value       = aws_lb.app_lb.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group (used by ASGs)"
  value       = aws_lb_target_group.app_lb_tg.arn
}

output "target_group_id" {
  description = "ID of the target group"
  value       = aws_lb_target_group.app_lb_tg.id
}