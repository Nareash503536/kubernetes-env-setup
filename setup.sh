#!/bin/bash
# ============================================================
# Quick Setup Script — Oracle Cloud VM (OL8/OL9 / RHEL-based)
# Installs: Docker, kubectl, Minikube, Helm
# ============================================================

set -e

echo "==> Updating system packages..."
sudo dnf update -y

# ============================================================
# 1. DOCKER
# ============================================================
echo "==> Installing Docker..."
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

# Allow current user to run docker without sudo
sudo usermod -aG docker $USER
echo "Docker installed: $(docker --version)"

# ============================================================
# 2. KUBECTL
# ============================================================
echo "==> Installing kubectl..."
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF

sudo dnf install -y kubectl
echo "kubectl installed: $(kubectl version --client)"

# ============================================================
# 3. MINIKUBE
# ============================================================
echo "==> Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
echo "Minikube installed: $(minikube version)"

# ============================================================
# 4. HELM
# ============================================================
echo "==> Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "Helm installed: $(helm version)"

# ============================================================
# 5. START MINIKUBE (using Docker driver)
# ============================================================
echo "==> Starting Minikube..."
# NOTE: newgrp applies docker group — run this manually after script
# or log out and back in first
minikube start --driver=docker --cpus=4 --memory=8192

echo ""
echo "============================================================"
echo " Setup Complete!"
echo "============================================================"
echo " Docker:    $(docker --version)"
echo " kubectl:   $(kubectl version --client --short 2>/dev/null)"
echo " Minikube:  $(minikube version --short)"
echo " Helm:      $(helm version --short)"
echo ""
echo " IMPORTANT: Log out and back in (or run 'newgrp docker')"
echo " to apply docker group membership before running minikube."
echo "============================================================"