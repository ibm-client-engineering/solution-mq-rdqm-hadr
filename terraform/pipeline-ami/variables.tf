variable "aws_access_key" {
  type        = string
  description = "The AWS access key used for creating the custom AMI."
}

variable "aws_secret_key" {
  type        = string
  description = "The AWS secret key used for creating the custom AMI."
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "The AWS region in which to create the custom AMI."
}

variable "build_version" {
  type        = string
  default     = "1.0.0"
  description = "A version identifier to trigger a new Packer build."
}