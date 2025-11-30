# acs730-finalproject-group10

# ACS730 Final Project - Two-Tier Web App (Complete)


## Overview
This repo implements the two-tier static web application required for ACS730 final project: VPC, 3 public subnets across 3 AZs, ALB, ASG backed EC2 instances serving a static site that loads an image from a private S3 bucket. Each environment (dev, staging, prod) uses its own S3 backend and DynamoDB lock table.


## Prerequisites
- AWS account and credentials configured (`aws configure`)
- Terraform >= 1.4
- `aws` CLI
- `tflint` (optional, used by GitHub Actions/in CI)
- `trivy` (optional, used by GitHub Actions)


## Important: Manual steps before running Terraform
1. Create S3 buckets for Terraform state for each environment (unique globally). Example:
- `group10-acs730-dev-tfstate`
- `group10-acs730-staging-tfstate`
- `group10-acs730-prod-tfstate`
2. Create a single DynamoDB table for remote state locking (or one per environment):
- Table name: `group10-acs730-terraform-locks` (string PK `LockID`)
3. Create 3 private S3 buckets to host the website image (per assignment requirement) and upload `site-image.jpg` to each one
one S3 bucket for each env (dev, prod, staging)
- `group10-acs730-dev-images`
- `group10-acs730-staging-images`
- `group10-acs730-prod-images`


## Quick deploy (example for dev)
1. Edit `environments/dev/terraform.tfvars` and set values (images_bucket, ami_id, etc.)
2. Initialize Terraform (from `environments/dev`):
```bash
terraform init -backend-config=../../backend_configs/backend-dev.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars

run these command befor plan
\rm -rf ~/.aws/credentials
aws sts get-caller-identity
