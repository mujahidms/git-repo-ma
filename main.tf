  
provider "aws" {
  region  = "us-east-1"
 
}


terraform {
  backend "s3" {
    bucket = "ctm-tf-state-file-ecs-bucket"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
