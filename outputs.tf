output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "arn" {
  description = "ARN of the EventBridge schedule"
  value       = try(aws_scheduler_schedule.this[0].arn, null)
}

output "name" {
  description = "Name of the EventBridge schedule"
  value       = try(aws_scheduler_schedule.this[0].name, null)
}

output "group_name" {
  description = "Name of the schedule group the schedule belongs to"
  value       = var.group_name
}
