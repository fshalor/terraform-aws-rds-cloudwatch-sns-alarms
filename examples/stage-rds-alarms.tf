# STAGE RDS ALARMS> 




########################
# Standard Alerting RDS instances ... Put BusinessHours and Critical in their own block 
# RDS instances to poke
variable "stage_rds_instances" {
  description = "Rds Instances to Configure Alarms For as Key and Value is Property"
  type = map
  default = {
    wiggle-rds-stage-1 = "WiggleWars"
    wiggle-rds-stage-s = "WiggleWars"
    radar-rds-stage = "WeatherHunterKids"
    eat-pork-stage      = "LambChops"
  }
}


module "stage_rds_alarms" {
  source            = "../../Modules/terraform-aws-rds-cloudwatch-sns-alarms/"
  db_instance_ids   = var.stage_rds_instances
  aws_sns_topic_arn = var.aws_sns_topic_BusinessHours
  environment = "STAGE" 
}

