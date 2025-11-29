bucket         = "group10-acs730-prod-tfstate"     
key            = "two-tier-app/prod/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "group10-acs730-terraform-locks"