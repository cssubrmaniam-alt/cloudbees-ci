#!/usr/bin/env bash
set -euo pipefail

echo "CloudBees PS Bootstrap - WSL Ubuntu"

ARCH="$(uname -m)"
echo "Detected architecture: ${ARCH}"

case "${ARCH}" in
  aarch64|arm64)
    KUBECTL_ARCH="arm64"
    HELMFILE_ARCH="arm64"
    AWS_ARCH="aarch64"
    ;;
  x86_64|amd64)
    KUBECTL_ARCH="amd64"
    HELMFILE_ARCH="amd64"
    AWS_ARCH="x86_64"
    ;;
  *)
    echo "Unsupported architecture: ${ARCH}"
    exit 1
    ;;
esac

echo "Installing base packages..."
sudo apt update
sudo apt install -y \
  curl wget unzip jq git make gnupg ca-certificates \
  lsb-release software-properties-common apt-transport-https \
  python3 python3-pip openjdk-21-jdk

echo "Installing Ansible..."
python3 -m pip install --user ansible
grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"

echo "Installing Node.js LTS..."
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
fi

echo "Installing Terraform..."
if ! command -v terraform >/dev/null 2>&1; then
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt install -y terraform
fi

echo "Installing Helm..."
if ! command -v helm >/dev/null 2>&1; then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo "Installing Helmfile..."
HELMFILE_VERSION="$(curl -s https://api.github.com/repos/helmfile/helmfile/releases/latest | jq -r .tag_name)"
curl -L -o /tmp/helmfile.tar.gz \
  "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}_linux_${HELMFILE_ARCH}.tar.gz"
tar -xzf /tmp/helmfile.tar.gz -C /tmp
sudo mv /tmp/helmfile /usr/local/bin/helmfile
sudo chmod +x /usr/local/bin/helmfile

echo "Installing kubectl..."
KUBECTL_VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
curl -L -o /tmp/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl"
chmod +x /tmp/kubectl
sudo mv /tmp/kubectl /usr/local/bin/kubectl

echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o "/tmp/awscliv2.zip"
rm -rf /tmp/aws
unzip -q /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install --update

echo "Installing Google Cloud CLI..."
if ! command -v gcloud >/dev/null 2>&1; then
  curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt update
  sudo apt install -y google-cloud-cli
fi

echo "Checking Docker..."
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found."
  echo "Install Docker Desktop for Windows ARM64 and enable WSL Integration for Ubuntu."
else
  docker --version
fi

echo "Bootstrap completed."
echo "Run: make phase1"
