variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

source "amazon-ebs" "redhat8" {
  region = "us-west-2"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "Red Hat Enterprise Linux 8.4*"
      root-device-type    = "ebs"
    }
    owners     = ["309956199498"]
    most_recent = true
  }
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "=IBM-MQ-REL8-${local.timestamp}"
  ami_description = "IBM MQ Red Hat Enterprise Linux 8"
  access_key     = var.aws_access_key
  secret_key     = var.aws_secret_key
  force_deregister = true
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

build {
  sources = ["source.amazon-ebs.redhat8"]

  provisioner "shell" {
    inline = [
      "sudo dnf update -y",

      # THIS IS WHERE YOU ADD STUFF FOLKS
      "sudo dnf install -y wget,lvm2",

    ]
  }
}