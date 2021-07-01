output "vpc_id" {
    description = "vpc id"
    value = aws_vpc.vpc.id
}

output "public_subnet" {
    description = "public subnet"
    value = aws_subnet.public_subnet.id
}

output "app_subnet" {
    description = "app subnet"
    value = aws_subnet.app_subnet.id
}

output "db_subnet" {
    description = "db subnet"
    value = aws_subnet.db_subnet.id
}

output "failover_public_subnet" {
    description = "failover public subnet"
    value = aws_subnet.failover_public_subnet.id
}

output "failover_app_subnet" {
    description = "failover app subnet"
    value = aws_subnet.failover_app_subnet.id
}

output "failover_db_subnet" {
    description = "failover db subnet"
    value = aws_subnet.failover_db_subnet.id
}

output "igw" {
    description = "igw"
    value = aws_internet_gateway.igw.id
}

output "vpc_cidr" {
    description = "vpc id"
    value = aws_vpc.vpc.cidr_block
}

output "alb_arn" {
    description = "alb arn"
    value = aws_lb.alb.arn
}

output "nat_id" {
    description = "nat_id"
    value = aws_nat_gateway.nat.id
}