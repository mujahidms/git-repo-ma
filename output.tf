
# This will give us back the load balancer DNS Name(A record) after we deploy
output "alb_dns" {
  value = aws_lb.ctm-lb.dns_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "igw_id" {
  value = module.vpc.igw_id
}
