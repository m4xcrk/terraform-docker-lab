terraform {
  required_version = ">= 1.5.0"
}

# Configuration for VM-01 (Nginx)
resource "null_resource" "nginx" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = "192.168.2.12"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f terraform-local-server || true",
      "sudo docker run -d --name terraform-local-server -p 8085:80 nginx:latest"
    ]
  }

  triggers = { always_run = timestamp() }
}

# Configuration for VM-02 (Apache)
resource "null_resource" "apache" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = "192.168.2.13"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f apache-server || true",
      "sudo docker run -d --name apache-server -p 8086:80 httpd:latest"
    ]
  }

  triggers = { always_run = timestamp() }
}

# Auto-generate the Inventory
resource "local_file" "ansible_inventory" {
  content  = <<EOT
[web_servers]
vm01 ansible_host=192.168.2.12
vm02 ansible_host=192.168.2.13

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
EOT
  filename = "${path.module}/inventory.ini"
}

# Monitoring: Prometheus Container
resource "null_resource" "prometheus" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = "192.168.2.12"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f prometheus || true",
      "sudo docker run -d --name prometheus -p 9090:9090 prom/prometheus"
    ]
  }

  triggers = { always_run = timestamp() }
}

# Monitoring: Grafana Container
resource "null_resource" "grafana" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = "192.168.2.12"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f grafana || true",
      "sudo docker run -d --name grafana -p 3000:3000 grafana/grafana"
    ]
  }

  triggers = { always_run = timestamp() }
}

