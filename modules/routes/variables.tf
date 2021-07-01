variable "module_name" {
  description = "module_name"
  type = string
}

variable "vpc_id" {
  description = "vpc_id"
  type = string
}

variable "igw" {
  description = "igw"
  type = string
}

variable "public_subnet" {
  description = "public_subnet"
  type = string
}

variable "app_subnet" {
  description = "app_subnet"
  type = string
}

variable "db_subnet" {
  description = "db_subnet"
  type = string
}

variable "failover_app_subnet" {
  description = "failover_app_subnet"
  type = string
}

variable "failover_public_subnet" {
  description = "failover_public_subnet"
  type = string
}

variable "failover_db_subnet" {
  description = "failover_db_subnet"
  type = string
}

variable "nat_id" {
  description = "nat_id"
  type = string
}