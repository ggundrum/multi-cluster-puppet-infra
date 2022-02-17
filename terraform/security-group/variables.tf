variable "region" {
  description = "This is the region that the resources will be deployed in"
  default = "us-west-1"
}

variable "home_ip_address" {
  description = "The public IPv4 address of your workstation"
  type = list(string)
  default = ["173.0.0.189/32"]
}

variable "vpc-id" {
  description = "The ID of the AWS VPC that the security group will be assigned to"
  default = "vpc-b75d51d2"
}