resource "helm_release" "redis_db" {
  name       = "my-db"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"

  # We use 'set' to make the app "Lite" for our 2GB RAM VMs
  set {
    name  = "master.persistence.enabled"
    value = "false"
  }

  set {
    name  = "replica.replicaCount"
    value = "0"
  }

  set {
    name  = "architecture"
    value = "standalone"
  }
}
