data "aws_caller_identity" "default" {}

resource "aws_db_event_subscription" "default" {
  for_each = var.db_instance_ids
  name_prefix = "rds-event-sub"
  sns_topic   = "${var.aws_sns_topic_arn}"

  source_type = "db-instance"
  source_ids  = ["${each.key}"]

  event_categories = [
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "recovery",
  ]

}

