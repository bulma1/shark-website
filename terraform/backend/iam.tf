resource "aws_iam_role" "ec2_role" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-codedeploy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ec2_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.provider_name}-${var.environment}-${var.app_name}-ec2-codedeploy-profile"
  role = aws_iam_role.ec2_role.name
}