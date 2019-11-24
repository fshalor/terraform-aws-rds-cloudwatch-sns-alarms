# Main bits for acount

provider "aws" {
  region                      = "us-east-1"
  shared_credentials_file     = "~/.aws/credentials"
  profile                     = "myslickname"
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}



############# Victor/Pagerduty/Etc and   Cloudwatch 
#

# Three. One for casual. One for Business Hours. One for OMG Critical.

#arn:aws:sns:us-east-1:AWS_ACCT_NUMBER:FSH-Default-Alarm
#arn:aws:sns:us-east-1:AWS_ACCT_NUMBER:FSH-BusinessHours-Alarm
#arn:aws:sns:us-east-1:AWS_ACCT_NUMBER:FSH-Critical-Alarm

# If using VicTOr Ops, use routing keys to send these to different queues. If using PGD... Each gets a service. 
# Example: 
# Routing Keys
# ops
# ops-business-hours
# ops-standard 


variable "aws_sns_topic_Critical" {
  default = "arn:aws:sns:us-east-1:AWS_ACCT_NUMBER:FSH-Critical-Alarm"
}

variable "aws_sns_topic_BusinessHours" {
  default = "arn:aws:sns:us-east-1:AWS_ACCT_NUMBER:FSH-BusinessHours-Alarm"
}

variable "aws_sns_topic_BusinessHours_Prod" {
  default = "arn:aws:sns:us-east-1:AWS_ACCT_NUMBER:FSH-BusinessHours-Alarm-Prod"
}

variable "aws_sns_topic_Standard" {
  default = "arn:aws:sns:us-east-1:AWS_ACCT_NUMBER:FSH-Default-Alarm"
}

