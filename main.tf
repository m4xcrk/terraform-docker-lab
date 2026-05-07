terraform {
  required_version = ">= 1.5.0"
}

# 1. VM-01: Operations Hub (Nginx LB, Prometheus, Grafana, Loki)
resource "null_resource" "nginx_lb" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = "192.168.2.12"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f nginx-lb || true",
      "sudo docker run -d --restart always --name nginx-lb -p 80:80 nginx:latest"
    ]
  }
  triggers = { always_run = timestamp() }
}

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

resource "null_resource" "loki" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = "192.168.2.12"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f loki || true",
      "sudo docker run -d --restart always --name loki -p 3100:3100 grafana/loki:latest"
    ]
  }
  triggers = { always_run = timestamp() }
}

# 2. Worker Nodes (VM-02 & VM-03)
resource "null_resource" "apache_vms" {
  for_each = toset(["192.168.2.13", "192.168.2.15"])
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
    host        = each.key
  }
  provisioner "remote-exec" {
    inline = [
      "sudo docker rm -f apache-server || true",
      "sudo docker run -d --restart always --name apache-server -p 8086:80 httpd:latest"
    ]
  }
  triggers = { always_run = timestamp() }
}

# 3. Inventory Generation
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
