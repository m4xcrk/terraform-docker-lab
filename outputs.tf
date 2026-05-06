output "lab_access_info" {
  value = {
    nginx_endpoint  = "http://192.168.2.12:8085"
    apache_endpoint = "http://192.168.2.13:8086"
    bastion_host    = "192.168.2.12"
    private_node    = "192.168.2.13"
  }
}
