variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "department" {
  description = "Department that is spinning up the instance"
  type        = string
  default     = "PSE"
}

variable "project" {
  description = "The name of the customer or technology"
  type        = string
  default     = ""
}

variable "termination_date" {
  description = "The date that the VM will be deleted"
  type        = string
  default     = "2022-2-28T00:00:00.000000+00:00"
}

variable "vpc_security_group_ids" {
  type = list(string)
  default = ["sg-04b96987ebb19c135"]
}

variable "home_ip_address" {
  description = "The public IPv4 address of your workstation"
  default = ["173.0.0.189/32"]
}


variable "username" {
  description = "This is the username variable this will get attached to your infra to make it unique"
  default = "pse-dev-user"
}

variable "initials"{
  description = "This is the intials of the username. This is used where it makes since to make a name as short as possible"
  default = "pdu"
}

variable "local_private_key_path" {
  description = "This is where the SSH key is located on your local workstation"
  default = "/Users/pse-dev-user/.ssh/dev-key"
}

variable "public_key" {
  description = "This is the public key portion of the private key that is used for local_private_key_path"
}

variable "region" {
  description = "This is the region that the resources will be deployed in"
  default = "us-west-1"
}

variable "vpc-id" {
  description = "The ID of the AWS VPC that the security group will be assigned to. The default is set to the default VPC in us-west-1"
  default = "vpc-b75d51d2"
}