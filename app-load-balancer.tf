# Creating ALB with Target groups , securit groups and listener
resource "aws_lb" "ctm-lb" {
  name               = "ctm-ecs-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  tags = {
    "env"       = "production"
    "createdBy" = "mamujahid"
  }
  security_groups = [aws_security_group.sg.id]
}

resource "aws_security_group" "sg" {
  name   = "allow-all-loadbalancer"
  vpc_id = data.aws_vpc.main.id
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
    "env"       = "production"
    "createdBy" = "mamujahid"
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "ctm-target-group"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.main.id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "ctm-web-listener" {
  load_balancer_arn = aws_lb.ctm-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}
