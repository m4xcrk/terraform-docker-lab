#!/bin/bash
BACKUP_DIR="$HOME/lab-backups/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "📦 Creating archive on VM-01..."
multipass exec VM-01 -- sudo tar -czf /home/ubuntu/grafana_backup.tar.gz -C /var/lib/docker/volumes/grafana-storage/_data .

echo "🚚 Transferring backup to Mac..."
scp -i ~/.ssh/id_ed25519 ubuntu@192.168.2.12:/home/ubuntu/grafana_backup.tar.gz "$BACKUP_DIR/"

# Backup Terraform State
cp terraform.tfstate "$BACKUP_DIR/"

echo "✅ Lab Backup Complete: $BACKUP_DIR"
