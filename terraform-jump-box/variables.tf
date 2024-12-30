variable "aws_region" {
  type    = string
  default = "ca-central-1"
}

variable "application" {
  type    = string
  default = "okd"
}

# VPC Variables

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "jumpbox_cidr" {
  description = "jumpbox_cidr"
  type        = string
}

variable "jumpbox_availability_zone" {
  description = "jumpbox_availability_zone"
  type        = string
  default     = "ca-central-1a"
}

variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
}

variable "instance_type" {
  description = "instance_type"
  type        = string
}

variable "local_key_file_name" {
  description = "local_key_file_name"
  type        = string
}

variable "instance_ami" {
  description = "instance_ami"
  type        = string
}

