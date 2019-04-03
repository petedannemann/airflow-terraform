variable "name_prefix" {
  description = "A string of text to place before each Name tag"
  default     = "airflow"
}

variable "region" {
  description = "AWS Region to deploy in"
  default     = "us-east-1"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "3"
}

variable "vpc_cidr_block" {
  description = "CIDR block of VPC"
  default     = "10.0.0.0/16"
}

variable "my_ip_address" {
  description = "My IP addresses to allow SSH"
  type        = "string"
}

variable "key" {
  description = "AWS SSH Key Pair name"
  type        = "string"
}

variable "ami" {
  description = "Ami of EC2 instance"
  default     = "ami-0a313d6098716f372" # Ubuntu Server 18.04 LTS
}

variable "instance_type" {
  description = "Instance type of EC2"
  default     = "t2-micro"
}

variable "db_password" {
  description = "Password to airflow metadata database"
  type        = "string"
}

