terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
  }
}

module "state_backend" {
  source = "github.com/tamu-edu/it-ae-tfmod-aws-state?ref=v0.0.3"

  bucket_name         = "test-it-ae-actions-terraform-pr-apply"
  dynamodb_table_name = "test-it-ae-actions-terraform-pr-apply"
}

module "github_oidc" {
  source = "github.com/tamu-edu/it-ae-tfmod-github-oidc?ref=v1.0.0"

  name = "allow-test-repo"
  subjects = [
    "repo:tamu-edu/it-ae-actions-terraform-pr-apply:*"
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]

  add_oidc_provider = false
}

output "role_arn" {
  value = module.github_oidc.role_arn
}
