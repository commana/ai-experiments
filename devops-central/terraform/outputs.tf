output "server_ip" {
  description = "IP des neuen VPS"
  value       = hcloud_server.main.ipv4_address
}

output "ssh_command" {
  description = "SSH Befehl zum Einloggen"
  value       = "ssh ubuntu@${hcloud_server.main.ipv4_address}"
}

output "next_steps" {
  value = <<EOT
1. Domain DNS konfigurieren (A-Records auf ${hcloud_server.main.ipv4_address})
2. ssh ubuntu@${hcloud_server.main.ipv4_address}
3. cd /opt/devops-central/scripts && ./bootstrap.sh
4. .env anpassen und docker compose up -d
EOT
}
