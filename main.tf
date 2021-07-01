#Use locals to configure this terraform program
locals {
    #Name this architecture for tagging and reference purposes
    architecture_name = "demo"
    #VPC cidr is 10.x.0.0/16 where vpc_config = x
    vpc_config = "0"
    #Specify a region
    region_config = "us-west-1"
    #Specify the first availability zone
    az1_config = "us-west-1a"
    #Specify the second availability zone
    az2_config = "us-west-1c"
}

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            # version = "-> 3.27"
        }
    }
}

provider "aws" {
    profile = "default"
    region = "${local.region_config}"
}

module "network" {
  source = ".//modules/network"
  module_name = "${local.architecture_name}_network"
  vpc_cidr = "10.${local.vpc_config}.0.0/16"
  public_cidr = "10.${local.vpc_config}.0.0/24"
  app_cidr = "10.${local.vpc_config}.1.0/24"
  db_cidr = "10.${local.vpc_config}.2.0/24"
  az1 = "${local.az1_config}"
  failover_public_cidr = "10.${local.vpc_config}.3.0/24"
  failover_app_cidr = "10.${local.vpc_config}.4.0/24"
  failover_db_cidr = "10.${local.vpc_config}.5.0/24"
  az2 = "${local.az2_config}"
  alb_security_group_id = module.security.alb_security_group_id
}

module "routes" {
  source = ".//modules/routes"
  module_name = "${local.architecture_name}_routes"
  vpc_id = module.network.vpc_id
  igw = module.network.igw
  public_subnet = module.network.public_subnet
  app_subnet = module.network.app_subnet
  db_subnet = module.network.db_subnet
  failover_app_subnet = module.network.failover_app_subnet
  failover_public_subnet = module.network.failover_public_subnet
  failover_db_subnet = module.network.failover_db_subnet
  nat_id = module.network.nat_id
}

module "database" {
    source = ".//modules/database"
    module_name = "${local.architecture_name}_database"
    db_subnet_az_primary = module.network.db_subnet
    db_subnet_az_failover = module.network.failover_db_subnet
    database_security_group_id = module.security.database_security_group_id
}

module "security" {
    source = ".//modules/security"
    module_name = "${local.architecture_name}_security"
    vpc_id = module.network.vpc_id
}

module "app" {
    source = ".//modules/app"
    module_name = "${local.architecture_name}_app"
    app_security_group = module.security.app_security_group
    autoscaling_subnet = module.network.app_subnet
    ecs_iam_role_name = module.security.ecs_iam_role_name
    failover_autoscaling_subnet = module.network.failover_app_subnet
    vpc_id = module.network.vpc_id
    alb_arn = module.network.alb_arn
    ecs_agent = module.security.ecs_agent_SSM_rule_applied
    db_user = module.database.db_user
    db_password = module.database.db_password
    db_host = module.database.db_host
}