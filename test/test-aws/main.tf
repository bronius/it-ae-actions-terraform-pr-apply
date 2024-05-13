terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
  }

  backend "s3" {
    bucket         = "test-it-ae-actions-terraform-pr-apply"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "test-it-ae-actions-terraform-pr-apply"
  }
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-it-ae-actions-terraform-pr-apply-test-bucket"
}
