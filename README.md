# kubernetes-env-setup

Easy setup for a Linux VM to work with Kubernetes.

Installs: **Docker**, **kubectl**, **Minikube**, **Helm**

---

## Quick Start

```bash
chmod +x setup.sh
./setup.sh
```

After the script completes, apply the Docker group membership without re-login:

```bash
newgrp docker
```

---

## Verify Installation

```bash
docker ps
kubectl get nodes
minikube status
helm version
```

---

## Start Minikube

After installation, `kubectl get nodes` will show connection errors because Minikube hasn't started yet:

```
The connection to the server localhost:8080 was refused - did you specify the right host or port?
🤷  Profile "minikube" not found. Run "minikube profile list" to view all profiles.
```

This is expected. Start Minikube with:

```bash
minikube start --driver=docker --cpus=4 --memory=8192
```

---

## Low Resource VMs (Oracle Cloud Free Tier)

If the above fails due to insufficient resources, check what's available first:

```bash
nproc      # check CPU count
free -h    # check available memory
```

Then start Minikube with reduced resources:

```bash
minikube start --driver=docker --cpus=2 --memory=4096
```

---

## After Minikube Starts

```bash
kubectl get nodes
# NAME       STATUS   ROLES           AGE   VERSION
# minikube   Ready    control-plane   Xs    v1.x.x
```

---

## Troubleshooting

### Docker permission denied
```bash
newgrp docker
# or log out and back in
```

### Firewall issues on Oracle Cloud VM
```bash
sudo firewall-cmd --zone=public --add-masquerade --permanent
sudo systemctl restart firewalld
```

### `dnf config-manager` not found
```bash
sudo dnf install -y 'dnf-command(config-manager)'
```

---

## Requirements

- Oracle Linux 8/9 or RHEL-based Linux VM
- Minimum 2 CPUs, 4GB RAM
- Internet access