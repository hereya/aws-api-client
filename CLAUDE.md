# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform-based Hereya package (DReAM package) that provisions AWS IAM users and credentials with configurable permissions for various AWS API access. It's designed to be used as a reusable infrastructure module.

## Commands

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy
```

## Architecture

The root module (`main.tf`) creates an IAM user with optional access keys (stored securely via SSM Parameter Store) and selectively includes permission modules based on the `permissions` variable.

### Module Structure

- **Root module**: Creates IAM user, access keys, and attaches policies from submodules
- **modules/cognito_admin**: Cognito User Pool admin permissions + optional user creation
- **modules/location_api**: AWS Location Service (place index search) permissions
- **modules/s3_bucket**: Creates S3 bucket with read/write permissions
- **modules/rekognition**: Face liveness detection permissions with assumable role

### Key Variables

- `permissions`: List of permission types to enable (`cognito_admin`, `location_api`, `s3_bucket`, `rekognition`)
- `export_credentials`: When `true`, creates IAM user with access keys
- Service-specific variables (e.g., `cognito_user_pool_id`, `place_location_index`, `s3_bucket_name_prefix`)

### Pattern

Each permission module:
1. Defines an `aws_iam_policy_document` named `permissions`
2. Outputs a `policy` attribute with the JSON policy document
3. The root module conditionally attaches these policies to the IAM user

The `hereyarc.yaml` identifies this as a Terraform-based package for AWS infrastructure.
