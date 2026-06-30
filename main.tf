# -----------------------------------------------------------------------------
# Atom: EventBridge Scheduler Schedule
#
# Creates a single aws_scheduler_schedule (Amazon EventBridge Scheduler — the
# modern, recommended replacement for CloudWatch Events scheduled rules). One
# schedule invokes one target (typically a Lambda) on a cron/rate/at expression,
# with an optional flexible time window, timezone, DLQ, and retry policy.
#
# Invocation IAM is intentionally OUT of scope for this atom — the caller passes
# a ready target_role_arn. Compose the role in tf-molecule-eventbridge-schedule-aws.
# -----------------------------------------------------------------------------
resource "aws_scheduler_schedule" "this" {
  count = module.this.enabled ? 1 : 0

  name        = module.this.id
  group_name  = var.group_name
  description = var.description
  state       = var.state
  kms_key_arn = var.kms_key_arn

  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone
  start_date                   = var.start_date
  end_date                     = var.end_date

  flexible_time_window {
    mode                      = var.flexible_time_window_mode
    maximum_window_in_minutes = var.flexible_time_window_mode == "FLEXIBLE" ? var.flexible_time_window_minutes : null
  }

  target {
    arn      = var.target_arn
    role_arn = var.target_role_arn
    input    = var.target_input

    dynamic "dead_letter_config" {
      for_each = var.dead_letter_arn != null ? [1] : []
      content {
        arn = var.dead_letter_arn
      }
    }

    dynamic "retry_policy" {
      for_each = (var.maximum_retry_attempts != null || var.maximum_event_age_in_seconds != null) ? [1] : []
      content {
        maximum_retry_attempts       = var.maximum_retry_attempts
        maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
      }
    }
  }
}
