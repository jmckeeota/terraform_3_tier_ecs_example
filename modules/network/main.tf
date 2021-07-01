resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.module_name}_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.module_name}_public_subnet"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.app_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.module_name}_app_subnet"
  }
}

resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.db_cidr
  availability_zone = var.az1

  tags = {
    Name = "${var.module_name}_db_subnet"
  }
}
resource "aws_subnet" "failover_public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.failover_public_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.module_name}_failover_public_subnet"
  }
}
resource "aws_subnet" "failover_app_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.failover_app_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.module_name}_failover_app_subnet"
  }
}

resource "aws_subnet" "failover_db_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.failover_db_cidr
  availability_zone = var.az2

  tags = {
    Name = "${var.module_name}_failover_db_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  depends_on = [
    aws_subnet.public_subnet,
    aws_vpc.vpc,
  ]

  tags = {
    Name = "${var.module_name}_igw"
  }
}

resource "aws_eip" "eip" {
  depends_on = [
    aws_internet_gateway.igw,
    ]
  vpc = true
  tags = {
    Name = "${var.module_name}_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.module_name}_nat"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.failover_public_subnet.id]
  depends_on = [aws_internet_gateway.igw
  ]

  tags = {
    Name = "${var.module_name}_alb"
  }
}