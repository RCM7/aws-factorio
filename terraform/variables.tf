
variable "aws_region" {
  description = "The AWS Region where to deploy resources"
  default = "eu-west-1"
}


variable "ami_id" {
  description = "The id of the AMI you want to use"
}
variable "spot_price" {
  description = "The maximum price per hour you'll allow to be charged"
  default = "0.03"
}

variable "instance_type" {
  description = "The AWS instance type you want to spin up"
  default = "m3.medium"
}

variable "subnet_id" {
  description = "The VPC subnet ID"
}

variable "key_name" {
  description = "The name of the SSH key to use for the instance"
}

variable "vpc_id" {
  description = "The ID of the VPC where factorio will be deployed"
}

variable "dns_domain" {
  description = "The DNS zone name"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for factorio backups"
}
