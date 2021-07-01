variable "module_name" {
  description = "module_name"
  type = string
}

variable "vpc_cidr" {
  description = "vpc"
  type = string
}

variable "az1" {
  description = "az1"
  type = string
}

variable "az2" {
  description = "az2"
  type = string
}

variable "public_cidr" {
  description = "public_cidr"
  type = string
}

variable "app_cidr" {
  description = "app_cidr"
  type = string
}

variable "db_cidr" {
  description = "db_cidr"
  type = string
}

variable "failover_public_cidr" {
  description = "failover_public_cidr"
  type = string
}

variable "failover_app_cidr" {
  description = "failover_app_cidr"
  type = string
}

variable "failover_db_cidr" {
  description = "failover_db_cidr"
  type = string
}

variable "alb_security_group_id" {
  description = "alb_security_group_id"
  type = string
}