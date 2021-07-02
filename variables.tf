#Modify this file to configure the environment

variable "architecture_name" {
  description = "Name this architecture for tagging and reference purposes (Default = demo)"
  default = "demo"
  type = string
}

variable "vpc_config" {
  description = "VPC cidr is 10.x.0.0/16 where vpc_config = x (Default = 0)"
  default = "0"
  type = string
}

variable "region_config" {
  description = "Specify the first availability zone (Default = us-west-1)"
  default = "us-west-1"
  type = string
}

variable "az1_config" {
  description = "Specify the second availability zone (Default = us-west-1a)"
  default = "us-west-1a"
  type = string
}

variable "az2_config" {
  description = "Specify the second availability zone (Default = us-west-1c)"
  default = "us-west-1c"
  type = string
}

variable "ami" {
  description = "Specify a simple AWS linux AMI from the region (Default = ami-09bc3667a66efbf89)"
  default = "ami-09bc3667a66efbf89"
  type = string
}