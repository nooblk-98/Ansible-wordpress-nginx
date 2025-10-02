variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_az" {
  type    = string
  default = "us-east-1a"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for Amazon Linux 2"
  default     = "ami-0c02fb55956c7d316"
}

variable "ssh_public_key" {
  type        = string
  description = "Your SSH public key for root access"
}

variable "key_name" {
  type        = string
  description = "Name of an existing AWS EC2 Key Pair to use for SSH"
}

variable "ec2_name" {
  type        = string
  description = "Name of EC2 "
}

