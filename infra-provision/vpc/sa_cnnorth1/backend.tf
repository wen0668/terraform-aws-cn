terraform {
  
    backend "s3" {
      bucket         = "steven-dev-cnnorth1-terraform-state"
      key            = "steven/terraform/vpc/sa_cnnorth1/terraform.tfstate"
      region         = "cn-north-1"
      encrypt        = true
      dynamodb_table = "terraform-lock"
    }
}