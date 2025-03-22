#!/bin/bash
# Stop and remove existing container
docker stop shark-website || true
docker rm shark-website || true

# Start new container with proper user permissions
docker run -d \
  --name shark-website \
  --user node \
  -p 80:8080 \
  -v /home/ec2-user/app-logs:/home/node/app/logs \
  --restart unless-stopped \
  ${ECR_REPO}:${ENVIRONMENT}