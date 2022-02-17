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
  default     = "2022-1-31T00:00:00.000000+00:00"
}

variable "vpc_security_group_ids" {
  type = list(string)
  default = ["sg-04b96987ebb19c135"]
}

variable "username" {
  type = string
  description = "This is the username variable this will get attached to your infra to make it unique"
  default = "pse-dev-user"
}