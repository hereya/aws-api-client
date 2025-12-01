output "policy" {
  description = "The IAM policy document for SSM Parameter Store access."
  value       = data.aws_iam_policy_document.permissions.json
}

output "path_prefix" {
  description = "The path prefix for SSM parameters"
  value       = var.path_prefix
}
