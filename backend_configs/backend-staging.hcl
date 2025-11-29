bucket         = "group10-acs730-staging-tfstate"     
key            = "two-tier-app/staging/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "group10-acs730-terraform-locks"