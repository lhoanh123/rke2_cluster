#!/bin/bash

# Set environment variables
export HOSTNAME="rancher.mylab.com"
export BOOTSTRAP_PASSWORD="admin"

# Add the Rancher and Jetstack Helm repositories
echo "Adding Rancher and Jetstack Helm repositories..."
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add jetstack https://charts.jetstack.io

# Update Helm repositories
echo "Updating Helm repositories..."
helm repo update

# Add the cert-manager CRD
echo "Applying cert-manager CRD..."
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.16.1/cert-manager.crds.yaml

# Install or upgrade cert-manager
echo "Installing or upgrading cert-manager..."
helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace

# Install or upgrade Rancher
echo "Installing or upgrading Rancher..."
helm upgrade -i rancher rancher-latest/rancher \
  --create-namespace \
  --namespace cattle-system \
  --set hostname="${HOSTNAME}" \
  --set bootstrapPassword="${BOOTSTRAP_PASSWORD}" \
  --set replicas=1

echo "Installation completed."
