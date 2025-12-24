# -Inception
*This project has been created as part of the 42 curriculum by khhihi.*

# Inception

## Description

**Inception** is a system administration and DevOps–oriented project whose goal is to deepen the understanding of **Docker** and **containerized infrastructure**.

The project consists of building a small, fully functional infrastructure using **Docker and Docker Compose**, where each service runs in its own container. The setup must follow strict rules regarding security, networking, data persistence, and configuration management.

Through this project, we learn how modern applications are deployed, isolated, secured, and orchestrated using container technologies instead of traditional virtual machines.

---

## Project Overview

The infrastructure is composed of multiple services, each running in its own Docker container:

- **NGINX**: acts as a secure reverse proxy using TLS
- **WordPress**: PHP application container
- **MariaDB**: database service
- **Docker Compose**: orchestrates all containers
- **Volumes**: ensure persistent data
- **Docker Network**: enables isolated communication between services

All services are built using **custom Dockerfiles**, without using pre-built images other than base images (e.g. `debian` or `alpine`).

---

## Instructions

### Requirements

- Linux (recommended: Debian/Ubuntu)
- Docker
- Docker Compose

### Installation

```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
