resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.provider_name}-${var.environment}-${var.app_name}-s3"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
