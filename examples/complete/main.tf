# Complete example: a schedule that invokes a Lambda every 15 minutes,
# spread across a 5-minute flexible window, retrying up to 3 times.
module "schedule" {
  source = "../../"

  namespace   = "eg"
  environment = "dev"
  name        = "notify-deliver"

  schedule_expression          = "rate(15 minutes)"
  schedule_expression_timezone = "UTC"

  target_arn      = "arn:aws:lambda:eu-west-1:123456789012:function:eg-dev-notify-deliver"
  target_role_arn = "arn:aws:iam::123456789012:role/eg-dev-scheduler"

  flexible_time_window_mode    = "FLEXIBLE"
  flexible_time_window_minutes = 5
  maximum_retry_attempts       = 3
}
