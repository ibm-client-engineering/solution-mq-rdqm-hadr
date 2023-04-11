provider "aws" {
  region = var.region
}

resource "null_resource" "packer_build" {
  triggers = {
    build_version = var.build_version
  }

  provisioner "local-exec" {
    command = "packer build -force -var 'aws_access_key=${var.aws_access_key}' -var 'aws_secret_key=${var.aws_secret_key}' ${path.module}/redhat8.pkr.hcl"
  }
}

data "aws_ami" "custom_redhat8" {
  most_recent = true
  filter {
    name   = "name"
    values = ["IBM-MQ-*"]
  }
  filter {
    name   = "owner-id"
    values = [data.aws_caller_identity.current.account_id]
  }
  owners = [data.aws_caller_identity.current.account_id]
}

data "aws_caller_identity" "current" {}