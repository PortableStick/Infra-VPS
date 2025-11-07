#!/bin/bash

echo "#===============================#"
echo "Préparation de l'environnement..."
echo "#===============================#"

echo "Veuillez entrer votre mot-de-passe..."
if [ "$EUID" -ne 0 ]; then 
    exec sudo "$0" "$@"
fi

# Mise-à-jour du système
sudo apt-get update -y
sudo apt-get upgrade -y

# Retirer les paquets indésirables
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Mise-en-place du repo docker
echo "Mise-en-place du dépôt Docker..."

sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Installation de Docker
echo "Installation de la dernière version de Docker..."

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Terminé

echo "#=====================#"
echo "Préparation terminée !"
echo "#=====================#"

echo "Pour tester l'installation, exécutez la commande suivante :"
echo "sudo docker run hello-world"

