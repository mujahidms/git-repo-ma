THIS REPO IS A DEMOTRATION OF THE GIVEN TASK WITH TERRAFORM MODULES.

CTM TECHNICAL TEST

1.	In this task, I have used Terraform to create entire infrastructure and AWS cloud provider. I have deployed the infrastructure in North Virginia (us-east-1) region.
2.	With this code, you will be able to run one command to deploy the entire application with the following resources:
•	A Virtual Private Cloud with 3 public subnets in 3 availability zones
•	Elastic Container Service (ECS), ECS service, task definition
•	Multiple running container instances
•	AWS Application load balancer (ALB) distributing traffic between the containers, AWS Target group , AWS autoscaling group and launch configuration 
•	Health checks and logs
3.	The docker image has been stored in AWS Elastic Container Registry
4.	Used awslogs log driver in container task definition to monitor ,store and access the log files from the containers.
How to reproduce the inftrasture using this code?
1.	Git clone https://github.com/mujahidms/CTM-Project.git
2.	 cd CTM-Project
3.	terraform init
4.	terraform plan
5.	terraform apply
6.	terraform destroy ( to delete the infrastructure) 
Note: to destroy the infra , the ec2 instances should be terminated manually. As ec2 instances are launched by the auto scaling group.

Note: I have deployed the infrastructure successfully, I have shared the screenshots of the final results in the github repo folders.
I have refactored the code to use reusable modules, I have demonstrated the code in CMT-project-with-modules repo. And as a enhancement to the code , all hard codes values shall be used a variables.


