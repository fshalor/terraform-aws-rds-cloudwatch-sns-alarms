locals {
  thresholds = {
    BurstBalanceThreshold     = "${min(max(var.burst_balance_threshold, 0), 100)}"
    CPUUtilizationThreshold   = "${min(max(var.cpu_utilization_threshold, 0), 100)}"
    CPUCreditBalanceThreshold = "${max(var.cpu_credit_balance_threshold, 0)}"
    DiskQueueDepthThreshold   = "${max(var.disk_queue_depth_threshold, 0)}"
    FreeableMemoryThreshold   = "${max(var.freeable_memory_threshold, 0)}"
    FreeStorageSpaceThreshold = "${max(var.free_storage_space_threshold, 0)}"
    SwapUsageThreshold        = "${max(var.swap_usage_threshold, 0)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "burst_balance_too_low" {
  for_each	      = var.db_instance_ids
  alarm_name          = "${var.environment}_RDS_${each.value}_burst_balance_too_low_${each.key}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["BurstBalanceThreshold"]}"
  alarm_description   = "${var.environment}_RDS_${each.value}_Average database storage burst balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = ["${var.aws_sns_topic_arn}"]
  ok_actions          = ["${var.aws_sns_topic_arn}"]

  dimensions = {
    DBInstanceIdentifier = "${each.key}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  for_each	      = var.db_instance_ids
  alarm_name          = "${var.environment}_RDS_${each.value}_cpu_utilization_too_high_${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["CPUUtilizationThreshold"]}"
  alarm_description   = "${var.environment}_RDS_${each.value}_Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = ["${var.aws_sns_topic_arn}"]
  ok_actions          = ["${var.aws_sns_topic_arn}"]

  dimensions = {
    DBInstanceIdentifier = "${each.key}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  for_each	      = var.db_instance_ids
  alarm_name          = "${var.environment}_RDS_${each.value}_cpu_credit_balance_too_low_${each.key}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["CPUCreditBalanceThreshold"]}"
  alarm_description   = "${var.environment}_RDS_${each.value}_Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = ["${var.aws_sns_topic_arn}"]
  ok_actions          = ["${var.aws_sns_topic_arn}"]

  dimensions = {
    DBInstanceIdentifier = "${each.key}"
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  for_each	      = var.db_instance_ids
  alarm_name          = "${var.environment}_RDS_${each.value}_disk_queue_depth_too_high_${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["DiskQueueDepthThreshold"]}"
  alarm_description   = "${var.environment}_RDS_${each.value}_Average database disk queue depth over last 10 minutes too high, performance may suffer"
  alarm_actions       = ["${var.aws_sns_topic_arn}"]
  ok_actions          = ["${var.aws_sns_topic_arn}"]

  dimensions = {
    DBInstanceIdentifier = "${each.key}"
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  for_each	      = var.db_instance_ids
  alarm_name          = "${var.environment}_RDS_${each.value}_freeable_memory_too_low_${each.key}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["FreeableMemoryThreshold"]}"
  alarm_description   = "${var.environment}_RDS_${each.value}_Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = ["${var.aws_sns_topic_arn}"]
  ok_actions          = ["${var.aws_sns_topic_arn}"]

  dimensions = {
    DBInstanceIdentifier = "${each.key}"
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  for_each	      = var.db_instance_ids
  alarm_name          = "${var.environment}_RDS_${each.value}_free_storage_space_threshold_${each.key}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["FreeStorageSpaceThreshold"]}"
  alarm_description   = "${var.environment}_RDS_${each.value}_Average database free storage space over last 10 minutes too low"
  alarm_actions       = ["${var.aws_sns_topic_arn}"]
  ok_actions          = ["${var.aws_sns_topic_arn}"]

  dimensions = {
    DBInstanceIdentifier = "${each.key}"
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  for_each	      = var.db_instance_ids
  alarm_name          = "${var.environment}_RDS_${each.value}_swap_usage_too_high_${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["SwapUsageThreshold"]}"
  alarm_description   = "${var.environment}_RDS_${each.value}_Average database swap usage over last 10 minutes too high, performance may suffer"
  alarm_actions       = ["${var.aws_sns_topic_arn}"]
  ok_actions          = ["${var.aws_sns_topic_arn}"]

dimensions = {
    DBInstanceIdentifier = "${each.key}"
  }
}
