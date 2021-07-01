#ROUTE TABLE FOR PUBLIC SUBNET

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = var.igw
  }

  tags = {
    Name = "${var.module_name}_public_subnet_route_table"
  }
}

resource "aws_route_table_association" "associate_with_public_subnet" {
  subnet_id      = var.public_subnet
  route_table_id = aws_route_table.public_subnet_route_table.id
}

#ROUTE TABLE FOR APP SUBNET
resource "aws_route_table" "app_subnet_route_table" {
  vpc_id = var.vpc_id

    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }

  tags = {
    Name = "${var.module_name}_app_subnet_route_table"
  }
}

resource "aws_route_table_association" "associate_with_app_subnet" {
  subnet_id      = var.app_subnet
  route_table_id = aws_route_table.app_subnet_route_table.id
}

#ROUTE TABLE FOR DB SUBNET
resource "aws_route_table" "db_subnet_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.module_name}_db_subnet_route_table"
  }
}

resource "aws_route_table_association" "associate_with_db_subnet" {
  subnet_id      = var.db_subnet
  route_table_id = aws_route_table.db_subnet_route_table.id
}

#ROUTE TABLE FOR FAILOVER PUBLIC SUBNET
resource "aws_route_table" "failover_public_subnet_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.module_name}_failover_public_subnet_route_table"
  }
}

resource "aws_route_table_association" "associate_with_failover_public__subnet" {
  subnet_id      = var.failover_public_subnet
  route_table_id = aws_route_table.failover_public_subnet_route_table.id
}

#ROUTE TABLE FOR FAILOVER FAILOVER APP SUBNET
resource "aws_route_table" "failover_app_subnet_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.module_name}_failover_app_subnet_route_table"
  }
}

resource "aws_route_table_association" "associate_with_failover_app_subnet" {
  subnet_id      = var.failover_app_subnet
  route_table_id = aws_route_table.failover_app_subnet_route_table.id
}

#ROUTE TABLE FOR FAILOVER DB SUBNET
resource "aws_route_table" "failover_db_subnet_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.module_name}_failover_db_subnet_route_table"
  }
}

resource "aws_route_table_association" "failover_associate_with_db_subnet" {
  subnet_id      = var.failover_db_subnet
  route_table_id = aws_route_table.failover_db_subnet_route_table.id
}