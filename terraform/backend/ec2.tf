resource "aws_instance" "shark_instance" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.shark_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data            = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo systemctl enable docker.service
              sudo systemctl start docker.service
              sudo usermod -a -G docker ec2-user

              # Create required directories
              mkdir -p /home/ec2-user/app /home/ec2-user/app-logs
              sudo chown ec2-user:ec2-user /home/ec2-user/app /home/ec2-user/app-logs
              sudo chmod 755 /home/ec2-user/app /home/ec2-user/app-logs
              mkdir -p /home/ec2-user/app /home/ec2-user/app-logs

              # Install CodeDeploy Agent
              sudo yum install ruby -y
              wget https://aws-codedeploy-${var.aws_region}.s3.${var.aws_region}.amazonaws.com/latest/install
              chmod +x ./install
              sudo ./install auto

              # Clear stale CodeDeploy deployment data
              sudo systemctl stop codedeploy-agent
              sudo rm -rf /opt/codedeploy-agent/deployment-root/*
              sudo systemctl start codedeploy-agent

              # Ensure CodeDeploy agent is enabled on boot
              sudo systemctl enable codedeploy-agent
              EOF
  tags = {
    Name        = "${var.app_name}"
    Environment = "${var.environment}"
    Provider    = "${var.provider_name}"
  }
}