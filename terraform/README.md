# Factorio Terraform

Terraform scripts to provision all the resources in AWS

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami_id | The id of the AMI you want to use | string | - | yes |
| aws\_account_id | The id of the AWS account where you'll be deploying factorio | string | - | yes |
| aws_region | The AWS Region where to deploy resources | string | `eu-west-1` | no |
| dns_domain | The DNS zone name | string | - | yes |
| instance_type | The AWS instance type you want to spin up | string | `m3.medium` | no |
| key_name | The name of the SSH key to use for the instance | string | - | yes |
| lambda\_auth_token | The Auth Token to set as environment variable of the lambda function. Used as (very) simple authentication method for now | string | - | yes |
| s3\_bucket_name | The name of the S3 bucket for factorio backups | string | - | yes |
| spot_price | The maximum price per hour you'll allow to be charged | string | `0.03` | no |
| spot\_request\_valid_until | The end date and time of the request, in UTC ISO8601 format (for example, YYYY-MM-DDTHH:MM:SSZ). At this point, no new Spot instance requests are placed or enabled to fulfill the request | string | `2018-10-01T03:00:00Z` | no |
| subnet_id | The VPC subnet ID | string | - | yes |
| vpc_id | The ID of the VPC where factorio will be deployed | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| api\_invoke_url | The URL to be used to make API calls |
| api_key | The API Key |
| auth_token | The Auth Token to set as environment variable of the lambda function. Used as (very) simple authentication method for now |

## Usage


```
# export env vars for terraform to use
$ export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
$ export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY


# create the zip file with the lambda function
$ zip -r manage_factorio.zip manage_factorio.js

# make a terraform plan and then apply it
$ terraform plan -var-file=factorio.tfvars -out terraform.plan
$ terraform apply terraform.plan
```

