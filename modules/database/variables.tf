variable "module_name" {
  description = "module_name"
  type = string
}

variable "db_subnet_az_primary" {
  description = "db_subnet_az_primary"
  type = string
}

variable "db_subnet_az_failover" {
  description = "db_subnet_az_secondary"
  type = string
}

variable "database_security_group_id" {
  description = "database_security_group_id"
  type = string
}