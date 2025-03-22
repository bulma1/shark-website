resource "aws_instance" "shark_instance" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.shark_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data            = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user

              # Install CodeDeploy Agent
              sudo yum install ruby -y
              wget https://aws-codedeploy-${var.aws_region}.s3.${var.aws_region}.amazonaws.com/latest/install
              chmod +x ./install
              sudo ./install auto
              sudo systemctl start codedeploy-agent
              EOF
  tags = {
    Name        = "${var.app_name}"
    Environment = "${var.environment}"
    Provider    = "${var.provider_name}"
  }
}