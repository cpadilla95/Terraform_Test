module "vpc" {
  source = "./modules/vpc"
}

## SECURITY GROUP ##
resource "aws_security_group" "test-lb-sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "Test Security Group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## LOAD BALANCER ##
resource "aws_lb" "test-alb" {
  name               = "test-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.test-lb-sg.id ]
  subnets            = module.vpc.subnets

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "test-alb-target" {
  name     = "test-lb-tg-tf"
  port     = var.port
  protocol = var.protocol
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "test-alb-listener" {
  load_balancer_arn = aws_lb.test-alb.id

  default_action {
    target_group_arn = aws_lb_target_group.test-alb-target.id
    type             = "forward"
  }
}

## LAUNCH TEMPLATE ##
resource "aws_launch_template" "test-launch-template" {
  name_prefix   = "test-launch-template"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

## ASG ##
resource "aws_autoscaling_group" "test-asg" {
  name                      = "test-asg"
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  default_instance_warmup   = var.warmup
  default_cooldown          = var.cooldown

  target_group_arns = [
    aws_lb_target_group.test-alb-target.arn
  ]

  launch_template {
    id      = aws_launch_template.test-launch-template.id
    version = "$Latest"
  }
}