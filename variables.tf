variable "app_port" {
  description = "The port for the Apache server"
  default     = "8086"
}

variable "ssh_key_path" {
  description = "Path to the private SSH key"
  default     = "~/.ssh/id_ed25519"
}
