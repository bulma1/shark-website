resource "aws_codedeploy_app" "shark_app" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}"
}
resource "aws_codedeploy_deployment_group" "shark_dg" {
  app_name              = aws_codedeploy_app.shark_app.name
  deployment_group_name = "${var.provider_name}-${var.environment}-${var.app_name}-dg"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = var.app_name
    }
    ec2_tag_filter {
      key   = "Environment"
      type  = "KEY_AND_VALUE"
      value = var.environment
    }
    ec2_tag_filter {
      key   = "Provider"
      type  = "KEY_AND_VALUE"
      value = var.provider_name
    }
  }

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
