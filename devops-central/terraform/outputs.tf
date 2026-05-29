output "server_ip" {
  description = "IP des neuen VPS (DNS hierauf zeigen!)"
  value       = hcloud_server.main.ipv4_address
}

output "ssh_command" {
  description = "SSH-Befehl"
  value       = "ssh ubuntu@${hcloud_server.main.ipv4_address}"
}

output "gitlab_url" {
  value = "https://gitlab.${var.lab_domain}"
}

output "artifactory_url" {
  value = "https://artifactory.${var.lab_domain}"
}
