resource "aws_codepipeline" "shark_pipeline" {
  name     = "${var.provider_name}-${var.environment}-${var.app_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  # Source Stage (GitHub)
  stage {
    name = "Source"
    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = "arn:aws:codeconnections:us-east-2:296062573273:connection/9bec4cc9-d38b-4a1c-b707-1884f9b64cfa"
        FullRepositoryId = "bulma1/shark-website"
        BranchName       = "main"
      }
    }
  }

  # Build Stage (CodeBuild)
  stage {
    name = "Build"
    action {
      name             = "CodeBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.shark_build.name
      }
    }
  }

  # Deploy Stage (CodeDeploy)
  stage {
    name = "Deploy"
    action {
      name            = "CodeDeploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"
      configuration = {
        ApplicationName     = aws_codedeploy_app.shark_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.shark_dg.deployment_group_name
      }
    }
  }
}