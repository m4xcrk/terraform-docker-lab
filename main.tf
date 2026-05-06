terraform {
  required_version = ">= 1.5.0"
}

# 1. VM-01: Nginx (Will become Load Balancer)
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
      "sudo docker run -d --restart always --name terraform-local-server -p 8085:80 nginx:latest"
    ]
  }
  triggers = { always_run = timestamp() }
}

# 2. VM-02: Apache Worker 1
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
      "sudo docker run -d --restart always --name apache-server -p 8086:80 httpd:latest"
    ]
  }
  triggers = { always_run = timestamp() }
}

# 3. VM-03: Apache Worker 2
resource "null_resource" "apache_worker_2" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = "192.168.2.15" 
  }
  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f apache-server || true",
      "sudo docker run -d --restart always --name apache-server -p 8086:80 httpd:latest"
    ]
  }
  triggers = { always_run = timestamp() }
}

# 4. Monitoring (Prometheus & Grafana) on VM-01
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
      "sudo docker run -d --restart always --name prometheus -p 9090:9090 prom/prometheus"
    ]
  }
  triggers = { always_run = timestamp() }
}

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
      "sudo docker run -d --restart always --name grafana -v grafana-storage:/var/lib/grafana -p 3000:3000 grafana/grafana"
    ]
  }
  triggers = { always_run = timestamp() }
}

# 5. Unified Ansible Inventory (No Duplicates)
resource "local_file" "ansible_inventory" {
  content  = <<EOT
[lb]
vm01 ansible_host=192.168.2.12

[web_servers]
vm02 ansible_host=192.168.2.13
vm03 ansible_host=192.168.2.15

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
EOT
  filename = "${path.module}/inventory.ini"
}

