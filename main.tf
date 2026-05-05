terraform {
  required_version = ">= 1.5.0"
}

resource "null_resource" "nginx" {
  provisioner "local-exec" {
    command = <<EOT
docker rm -f terraform-local-server || true
docker run -d --name terraform-local-server -p 8085:80 nginx:latest
EOT
  }

  # ensures it runs again if you re-apply
  triggers = {
    always_run = timestamp()
  }
}
