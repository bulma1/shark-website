resource "aws_ecr_repository" "shark-website" {
  name                 = "${var.provider_name}-${var.environment}-${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}