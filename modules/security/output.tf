output "app_security_group" {
    description = "app_security_group"
    value = aws_security_group.application_security_group.id
}

output "ecs_iam_role_name" {
    description = "ecs_iam_role"
    value = aws_iam_instance_profile.ecs_agent.name
}

output "alb_security_group_id" {
    description = "alb_security_group_id"
    value = aws_security_group.alb_security_group.id
}

output "ecs_agent_SSM_rule_applied" {
    value = true #value is irrelevant
    description = "ecs_agent_SSM_rule_applied"
    depends_on = [
      aws_iam_instance_profile.ecs_agent
    ]
}

output "database_security_group_id" {
    value = aws_security_group.database_security_group.id
    description = "database_security_group_id"
}
