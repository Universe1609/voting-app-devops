terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket         = "todo-list-devsecops-project"
    key            = "estado/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "todo-list-devsecops-table"
  }
}
