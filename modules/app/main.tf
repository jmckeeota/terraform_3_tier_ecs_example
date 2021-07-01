resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = "ami-09bc3667a66efbf89"
    iam_instance_profile = var.ecs_iam_role_name
    security_groups      = [var.app_security_group]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.module_name}_cluster >> /etc/ecs/ecs.config"
    instance_type        = "t2.micro"
}

#Instance Autoscaling
resource "aws_autoscaling_group" "app_autoscaling_group" {
    name                      = "app_autoscaling_group"
    vpc_zone_identifier       = [var.autoscaling_subnet]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 2
    health_check_grace_period = 90
    health_check_type         = "ELB"
    
}

resource "aws_autoscaling_group" "failover_app_autoscaling_group" {
    name                      = "failover_app_autoscaling_group"
    vpc_zone_identifier       = [var.failover_autoscaling_subnet]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 0
    min_size                  = 0
    max_size                  = 0
    health_check_grace_period = 90
    health_check_type         = "ELB"
    depends_on = [
      var.ecs_agent
    ]
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "albTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "${var.module_name}_alb_target_group"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = var.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

#ECS AUTOSCALING
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main_cluster.name}/${aws_ecs_service.phpmyadmin.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "ecs_scale_policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 40.0
  }
}


resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.module_name}_cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_task_definition" "phpmyadmin" {
  family = "phpmyadmin_task_definition"
  container_definitions = <<DEFINITION
  [
      {
          "portMappings": [
              {
                  "hostPort": 0,
                  "protocol": "tcp",
                  "containerPort": 80
              }
          ],
          "cpu": 10,
          "memory": 300,
          "image": "phpmyadmin",
          "name": "phpmyadmin",
          "environment": [
              {
            "name": "PMA_HOST",
            "value": "${var.db_host}"
          },
          {
            "name": "PMA_USER",
            "value": "${var.db_user}"
          },
          {
            "name": "PMA_PASSWORD",
            "value": "${var.db_password}"
          }
        ]
      }
  ]
  DEFINITION
  }
  

resource "aws_ecs_service" "phpmyadmin" {
  name            = "phpmyadmin"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.phpmyadmin.arn
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "phpmyadmin"
    container_port   = 80
  }
  depends_on = [
    aws_autoscaling_group.app_autoscaling_group,
    var.alb_arn,
  ]
}