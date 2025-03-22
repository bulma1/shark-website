# S3 Bucket for Artifacts (add this if not existing)
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.provider_name}-${var.environment}-${var.app_name}-codepipeline-artifacts"
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}