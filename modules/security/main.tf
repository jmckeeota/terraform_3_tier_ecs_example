#Create Security Groups

resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "Allow 80 and 8080 from igw"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.module_name}_alb_security_group"
  }
}

resource "aws_security_group" "application_security_group" {
  name        = "application_security_group"
  description = "Accept traffic from load balancer"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.module_name}_application_security_group"
  }
}

resource "aws_security_group" "database_security_group" {
  name        = "database_security_group"
  description = "Accepts only database traffic from application sg"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.module_name}_database_security_group"
  }
}

#Security Group Rules
resource "aws_security_group_rule" "allow_traffic_from_alb_to_app" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.application_security_group.id
  source_security_group_id = aws_security_group.alb_security_group.id
}

resource "aws_security_group_rule" "allow_traffic_from_app_to_alb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_security_group.id
  source_security_group_id = aws_security_group.application_security_group.id
}

resource "aws_security_group_rule" "allow_internet_traffic_to_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_mysql_traffic_from_app_to_database" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.database_security_group.id
  source_security_group_id = aws_security_group.application_security_group.id
}

resource "aws_security_group_rule" "allow_mysql_traffic_from_database_to_app" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.application_security_group.id
  source_security_group_id = aws_security_group.database_security_group.id
}

resource "aws_security_group_rule" "allow_traffic_from_alb_to_anywhere" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_traffic_from_app_to_anywhere" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.application_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_traffic_from_database_to_anywhere" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.database_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# IAM POLICIES
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs_agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "SSM_Managed_Instance_Core" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "SSM_Patch_Association" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs_agent"
  role = aws_iam_role.ecs_agent.name
  depends_on = [
    aws_iam_role_policy_attachment.ecs_agent,
    aws_iam_role_policy_attachment.SSM_Managed_Instance_Core,
    aws_iam_role_policy_attachment.SSM_Patch_Association
  ]
}

