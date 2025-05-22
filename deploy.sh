#!/bin/bash
cd /home/${RUTH_SERVER_USER}/RuthAPI

# Update the system
sudo apt update -y
sudo apt upgrade -y

# Docker & Docker Compose Installation Check
if ! [ -x "$(command -v docker)" ]; then
  echo "Docker is not installed. Installing..."
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  echo "Docker Installation Done"
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  echo "Docker Compose is not installed. Installing..."
  sudo apt install docker-compose-plugin -y
  echo "Docker Compose Installation Done"
fi

# Shutdown previous running containers
docker-compose down

# Clean up docker containers, images, and volumes
docker system prune -af

# Remove all stopped containers
docker volume prune -f

# Fetch the latest image
export $(grep -v '^#' .env | xargs)
docker pull ${DOCKER_HUB_USERNAME}/ruthapi:latest

# Run the container
docker compose --env-file .env up -d

# Print success message
echo "Deployment completed successfully"