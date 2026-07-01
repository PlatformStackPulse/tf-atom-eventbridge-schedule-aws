# Unit Tests — tf-atom-eventbridge-schedule-aws
#
# Plan-only tests using a mocked AWS provider — no real AWS calls are made.
# Run with:         terraform test
# Run verbose:      terraform test -verbose
# Run specific:     terraform test -run "creates_when_enabled"

mock_provider "aws" {}

variables {
  # tf-label labels
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Required module inputs
  schedule_expression = "rate(5 minutes)"
  target_arn          = "arn:aws:lambda:eu-west-1:123456789012:function:eg-test-thing"
  target_role_arn     = "arn:aws:iam::123456789012:role/eg-test-thing-scheduler"
}

# ---------------------------------------------------------------------------
# Test: with valid inputs the schedule is created and outputs are populated
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled"
  }

  assert {
    condition     = aws_scheduler_schedule.this[0].schedule_expression == "rate(5 minutes)"
    error_message = "schedule_expression should be passed through to the resource"
  }

  assert {
    condition     = output.group_name == "default"
    error_message = "group_name output should default to 'default'"
  }
}

# ---------------------------------------------------------------------------
# Test: enabled = false creates no resources (arn output is null)
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.arn == null
    error_message = "arn output must be null when the module is disabled"
  }

  assert {
    condition     = length(aws_scheduler_schedule.this) == 0
    error_message = "no schedule resource should be planned when disabled"
  }
}
