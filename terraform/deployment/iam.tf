data "aws_ecr_repository" "shark-website" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-ecr"
}
resource "aws_iam_role" "codebuild_role" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "ec2:DescribeInstances",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "ecr:GetDownloadUrlForLayer"
        Resource = data.aws_ecr_repository.shark-website.arn
      },
      {
        Effect = "Allow"
        Action = [
          "codeconnections:UseConnection",
          "codeconnections:GetConnection",
          "codeconnections:ListConnections"
        ]
        Resource = "arn:aws:codeconnections:us-east-2:296062573273:connection/9bec4cc9-d38b-4a1c-b707-1884f9b64cfa"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::buma-dev-shark-website-codepipeline-artifacts", # TODO
          "arn:aws:s3:::buma-dev-shark-website-codepipeline-artifacts/*"
        ]
      }

    ]
  })
}
# CodeDeploy IAM Role
resource "aws_iam_role" "codedeploy_service_role" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy" "codedeploy_s3_access" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-s3-access"
  role = aws_iam_role.codedeploy_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetBucketLocation",
          "s3:GetObjectAcl"
        ],
        Resource = [
          "arn:aws:s3:::buma-dev-shark-website-codepipeline-artifacts",
          "arn:aws:s3:::buma-dev-shark-website-codepipeline-artifacts/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      }
    ]
  })
}

# CodePipeline IAM Role
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["codepipeline.amazonaws.com"
          ]
        }
      }
    ]
  })
}
# CodePipeline IAM Policy
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetDeployment",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:GetBucketVersioning"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codeconnections:UseConnection",
          "codeconnections:GetConnection",
          "codeconnections:ListConnections",
          "codeconnections:TagResource",
          "codeconnections:PassConnection"
        ]
        Resource = "arn:aws:codeconnections:us-east-2:296062573273:connection/9bec4cc9-d38b-4a1c-b707-1884f9b64cfa"
      },
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection",
          "codestar-connections:GetConnection",
          "codestar-connections:ListConnections"
        ]
        Resource = "arn:aws:codeconnections:us-east-2:296062573273:connection/9bec4cc9-d38b-4a1c-b707-1884f9b64cfa"
      },
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::buma-dev-shark-website-codepipeline-artifacts",
          "arn:aws:s3:::buma-dev-shark-website-codepipeline-artifacts/*"
        ]
      }
    ]
  })
}
