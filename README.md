Thank you for viewing this Terraform demonstration!

![Architecture_picture](https://github.com/jmckeeota/terraform_3_tier_ecs_example/blob/master/Design.png)

This project represents an ECS twist on the traditional three-tier web service.  I created it mostly to become better aquainted with ECS and Terraform.  

Tasks from ECS autoscaling are launched in an application subnet running instances of [phpmyadmin](https://hub.docker.com/_/phpmyadmin) which are connected to an RDS instance in a separate subnet. These tasks are accessible through an internet-facing load balancer on port 80.

Architecture demonstrates:
- A configurable root variables.tf file
- An application subnet with groups and routing that allow secure and limited one-way flow of traffic
- IAM permissions that allow bastionless SSM connections to instances in the application subnet
- Task-level load balancing
- With just a few changes, the architecture can be converted to a failover AZ design or switched to a high-availabiliy model with the load balancer servicing two application subnets in different AZs
