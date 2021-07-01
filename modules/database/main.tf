resource "aws_db_subnet_group" "db_group" {
  name       = "main"
  subnet_ids = [var.db_subnet_az_primary, var.db_subnet_az_failover]

  tags = {
    Name = "${var.module_name}_db_subnet_group"
  }
}

resource "aws_db_instance" "my_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  db_subnet_group_name = aws_db_subnet_group.db_group.name
  instance_class       = "db.t2.micro"
  name                 = "db"
  vpc_security_group_ids = [var.database_security_group_id]
  #The below username and password is only provided here for simplicity. Database crededntials should not be stored in plaintext.  KMS, Secrets Manager, or other means of storing secrets should be used.
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

tags = {
   Name = "${var.module_name} db"
  }
}