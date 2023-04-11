output "custom_ami_id" {
  value       = data.aws_ami.custom_redhat8.id
  description = "The ID of the custom Red Hat Enterprise Linux 8 AMI."
}

output "custom_ami_name" {
  value       = data.aws_ami.custom_redhat8.name
  description = "The name of the custom Red Hat Enterprise Linux 8 AMI."
}