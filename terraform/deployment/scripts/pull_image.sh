#!/bin/bash
# Pull latest Docker image
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
docker pull ${ECR_REPO}:${ENVIRONMENT}