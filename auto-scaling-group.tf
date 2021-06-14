data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

resource "aws_security_group" "aws-ec2-sg" {
  name        = "allow-all-ec2"
  description = "allow all"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mkerimova"
  }
}

resource "aws_launch_configuration" "aws_lc" {
  name          = "ctm_ecs"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile        = aws_iam_instance_profile.ctm-ecs-instance-profile.name
  key_name                    = var.key_name
  security_groups             = [aws_security_group.aws-ec2-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "aws_asg" {
  name                      = "ctm-aws-asg"
  launch_configuration      = aws_launch_configuration.aws_lc.name
  min_size                  = 3
  max_size                  = 4
  desired_capacity          = 3
  health_check_type         = "EC2"
  health_check_grace_period = 120
  vpc_zone_identifier       = module.vpc.public_subnets

  target_group_arns     = [aws_lb_target_group.lb_target_group.arn]

  # To enable ECS managed scaling , I need to enable "protect from scale"
  protect_from_scale_in = true
  
  # This lifecycle meta argument ensure that a new replacement object is created first 
  # and earlier object is destroyed after teh replacment is created
  lifecycle {
    create_before_destroy = true
  }
}
