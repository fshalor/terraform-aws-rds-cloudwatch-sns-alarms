

# terraform-aws-rds-cloudwatch-sns-alarms


Terraform module that configures important RDS alerts using CloudWatch and sends them to an SNS topic.

Create a set of sane RDS CloudWatch alerts for monitoring the health of an RDS instance.

This is a modification off of the CloudPosse code which fills a specific use case:
  1. You have tens of RDS instances already existing which are not alarmed
  2. You need alarms on them which make sense
  3. For either policy reasons, or danger-close reasons, you are unable to import existing RDS instances into Terraform and recreate them using the original module
  4. [BOFH] You need alarms on them NOW so you can meet your mates at the pub ten minutes ago. 

---


It's 100% Open Source and licensed under the [APACHE2](LICENSE).



## Requirements:

This assumes you have a few things:
  * existing SNS topics, for which already point to your on-call queues the way you need
  * RDS instances
  * Production Change Control Permission (right? everyone has this)  ( No... don't use this in prod on a Friday. Please. ) 

## Future Work:

In the next few weeks, I'll be making some modifications to override local variables for thresholds and allow them to be specified either via map or a data look up or some other method. The default Cloudposse values for thresholds are *good* from what I can see. 



## Usage


| area    | metric           | comparison operator  | threshold | rationale                                                                                                                                                                                              |
|---------|------------------|----------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Storage | BurstBalance     | `<`                  | 20 %      | 20 % of credits allow you to burst for a few minutes which gives you enough time to a) fix the inefficiency, b) add capacity or c) switch to io1 storage type.                                         |
| Storage | DiskQueueDepth   | `>`                  | 64        | This number is calculated from our experience with RDS workloads.                                                                                                                                      |
| Storage | FreeStorageSpace | `<`                  | 2 GB      | 2 GB usually provides enough time to a) fix why so much space is consumed or b) add capacity. You can also modify this value to 10% of your database capacity.                                         |
| CPU     | CPUUtilization   | `>`                  | 80 %      | Queuing theory tells us the latency increases exponentially with utilization. In practice, we see higher latency when utilization exceeds 80% and unacceptable high latency with utilization above 90% |
| CPU     | CPUCreditBalance | `<`                  | 20        | One credit equals 1 minute of 100% usage of a vCPU. 20 credits should give you enough time to a) fix the inefficiency, b) add capacity or c) don't use t2 type.                                        |
| Memory  | FreeableMemory   | `<`                  | 64 MB     | This number is calculated from our experience with RDS workloads.                                                                                                                                      |
| Memory  | SwapUsage        | `>`                  | 256 MB    | Sometimes you can not entirely avoid swapping. But once the database accesses paged memory, it will slow down.                                                                                         |




## Examples


See the [`examples/`](examples/) directory for working examples.

```hcl
variable "rds_instances" {
  description = "Rds Instances to Configure Alarms For as Key and Value is Property"
  type = map
  default = {
    test-rds-instance = "WiggleWars"
  }
}

module "dev_rds_alarms" {
  source            = "../../Modules/terraform-aws-rds-cloudwatch-sns-alarms/"
  db_instance_ids   = var.rds_instances
  aws_sns_topic_arn = var.aws_sns_topic_Standard
  environment = "DEV"
}

```




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| burst_balance_threshold | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available. | string | `20` | no |
| cpu_credit_balance_threshold | The minimum number of CPU credits (t2 instances only) available. | string | `20` | no |
| cpu_utilization_threshold | The maximum percentage of CPU utilization. | string | `80` | no |
| db_instance_id | The instance ID of the RDS database instance that you want to monitor. | string | - | yes |
| disk_queue_depth_threshold | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. | string | `64` | no |
| free_storage_space_threshold | The minimum amount of available storage space in Byte. | string | `2000000000` | no |
| freeable_memory_threshold | The minimum amount of available random access memory in Byte. | string | `64000000` | no |
| swap_usage_threshold | The maximum amount of swap space used on the DB instance in Byte. | string | `256000000` | no |

## Outputs

Currently none. 0.12 sort of doesn't need them. The ideal outputs would be the CW alarms, but they're basically pounded all over the screen on apply, and not useful outside of the scope of the module. 


## Contributing

### Bug Reports & Feature Requests

Please use the issue tracker above. 

### Developing

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

**NOTE:** There is no intention of PRing this fork back into CloudPosse/origin. It's a derrived thing for a specific use case. 


## Copyright


Copyright © 2019 [StackToSea](https://www.stacktosea.com)
Copyright © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.





## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

I've gotta maintain props to the Cloudposse people. I've learned a lot from their code.

Check out Cloudposse if you use this or like this. Their stuff is good. 

  [docs]: https://docs.cloudposse.com/
  [website]: https://cloudposse.com/
  [github]: https://github.com/cloudposse/
  [commercial_support]: https://github.com/orgs/cloudposse/projects
  [jobs]: https://cloudposse.com/jobs/
  [hire]: https://cloudposse.com/contact/
  [slack]: https://slack.cloudposse.com/
  [linkedin]: https://www.linkedin.com/company/cloudposse
  [twitter]: https://twitter.com/cloudposse/
  [email]: mailto:hello@cloudposse.com


### Contributors

 See the Original: 

