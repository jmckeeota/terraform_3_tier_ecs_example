variable "module_name" {
  description = "module_name"
  type = string
}

variable "app_security_group" {
  description = "app_security_group"
  type = string
}

variable "autoscaling_subnet" {
  description = "autoscaling_subnet"
  type = string
}

variable "ecs_iam_role_name" {
  description = "ecs_iam_role"
  type = string
}

variable "failover_autoscaling_subnet" {
  description = "failover_autoscaling_subnet"
  type = string
}

variable "vpc_id" {
  description = "vpc_id"
  type = string
}

variable "alb_arn" {
  description = "alb_arn"
  type = string
}

variable "ecs_agent" {
  description = "SSM_Managed_Instance_Core_id"
  type = string
}

variable "db_user" {
  description = "db_user"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "db_password"
  type = string
  sensitive = true
}

variable "db_host" {
  description = "db_host"
  type = string
  sensitive = true
}