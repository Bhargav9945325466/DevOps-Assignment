terraform {
  backend "s3" {
    bucket         = "devops-assignment-tf-state-bhargav"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}