resource "aws_ecs_cluster" "ctm-ecs-cluster" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.ctm-ecs-cp.name]
  tags = {
    "env"       = "development"
    "createdBy" = "mamujahid"
  }
}

# capacity provider(CP) for ASG for EC2 instacnes, 
# managed scaling is enabled, when creating the CP , ECS manages 
# scale-in & scale-out actions of ASG.

resource "aws_ecs_capacity_provider" "ctm-ecs-cp" {
  name = "capacity-provider-ctm-ecs-cp"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.aws_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}


# update file task-def, so it's pulling image from ecr
resource "aws_ecs_task_definition" "task-definition-ctm" {
  family                = "ctm-family"
  container_definitions = file("task-definitions/task-def.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "development"
    "createdBy" = "mamujahid"
  }
}

resource "aws_ecs_service" "ctm-service" {
  name            = "ctm-service"
  cluster         = aws_ecs_cluster.ctm-ecs-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-ctm.arn
  desired_count   = 2
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "ctm-container"
    container_port   = 80
    
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.ctm-web-listener]
}

# Streaming instance logs to CloudWatch Logs
resource "aws_cloudwatch_log_group" "ctm-cw-lg" {
  name = "/ecs/ctm-app-container"
  tags = {
    "env"       = "development"
    "createdBy" = "mamujahid"
  }
}
