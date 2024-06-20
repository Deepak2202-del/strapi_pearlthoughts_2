# variables.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "private_key" {
  description = "SSH Private Key for accessing the EC2 instance"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

