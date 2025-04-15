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
variable "account_id" {
  type    = string
  default = "296062573273"
}