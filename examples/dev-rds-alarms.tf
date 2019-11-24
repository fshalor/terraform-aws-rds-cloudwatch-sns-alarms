# DEV RDS ALARMS> 

### For connecting and provisioning
variable "region" {
  default = "us-east-1"
}




########################
# Standard Alerting RDS instances ... Put BusinessHours and Critical in their own block 
# RDS instances to poke
variable "rds_instances" {
  description = "Rds Instances to Configure Alarms For as Key and Value is Property"
  type = map
  default = {
    test-rds-instance = "WiggleWars"
    radar-rds-dev = "WeatherHunterKids" 
    eat-pork-dev      = "LambChops"
  }
}

module "dev_rds_alarms" {
  source            = "../../Modules/terraform-aws-rds-cloudwatch-sns-alarms/"
  db_instance_ids   = var.rds_instances
  aws_sns_topic_arn = var.aws_sns_topic_Standard
  environment = "DEV"
}

