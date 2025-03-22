resource "aws_codebuild_project" "shark_build" {
  name          = "${var.app_name}-${var.environment}-build"
  build_timeout = 60
  description   = "Build project of shark website"
  service_role  = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE" # Outputs artifacts to CodePipeline
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0" # Includes Node.js and Docker
    type            = "LINUX_CONTAINER"
    privileged_mode = true # Required for Docker builds
    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "ECR_REPO"
      value = data.aws_ecr_repository.shark-website.repository_url
    }
    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  # Webhook to trigger builds on GitHub push
  source_version = "main" # Adjust if your default branch is different
}