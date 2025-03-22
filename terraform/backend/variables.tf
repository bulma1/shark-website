variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  default     = "t2.micro"                 # Default value for the variable
  description = "The type of EC2 instance" # Description of what this variable represents
}
variable "ami_id" {
  type        = string
  default     = "ami-05716d7e60b53d380"
  description = "The Amazon Linux 2023 AMI"
}
variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS Region"
}
variable "app_name" {
  type    = string
  default = "shark-website"
}
variable "provider_name" {
  type = string
}
variable "environment" {
  type        = string
  description = "The environment must contains ( dev , staging , prod ) "
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of: dev, staging, or prod."
  }
}