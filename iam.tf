
## In this file, setting up some security groups to make sure our app is prorerly protected
resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role-ctm-web"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [ 
          "ecs.amazonaws.com",
          "ec2.amazonaws.com"
          ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ctm-ecs-instance-profile" {
  role = aws_iam_role.ecs-instance-role.name
}
