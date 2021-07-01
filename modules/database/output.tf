output "db_user" {
    description = "app subnet"
    value = aws_db_instance.my_db.username
    sensitive = true
}

output "db_password" {
    description = "app subnet"
    value = aws_db_instance.my_db.password
    sensitive = true
}

output "db_host" {
    description = "app subnet"
    value = aws_db_instance.my_db.endpoint
    sensitive = true
}