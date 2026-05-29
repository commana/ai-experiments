resource "hcloud_ssh_key" "main" {
  name       = "${var.server_name}-key"
  public_key = var.ssh_public_key
}

resource "hcloud_server" "main" {
  name        = var.server_name
  server_type = var.server_type
  image       = "ubuntu-24.04"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.main.name]

  user_data = file("${path.module}/cloud-init.yaml")

  labels = {
    project = "devops-central"
    purpose = "on-demand-lab"
  }

  # Vollautomatisches Setup: Clone + .env rendern + Stack starten
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "echo '=== DevOps Central - Automatisches Setup ==='",
      "git clone https://github.com/commana/ai-experiments.git /opt/devops-central || true",
      "cd /opt/devops-central/compose",
      "cp -n .env.example .env",
      "sed -i 's|LAB_DOMAIN=.*|LAB_DOMAIN=${var.lab_domain}|g' .env",
      "sed -i 's|ADMIN_EMAIL=.*|ADMIN_EMAIL=${var.admin_email}|g' .env",
      "sed -i 's|GITLAB_ROOT_PASSWORD=.*|GITLAB_ROOT_PASSWORD=${var.gitlab_root_password}|g' .env",
      "echo ' .env angepasst'",
      "docker compose pull",
      "docker compose up -d",
      "echo '✅ Stack automatisch gestartet!'",
      "echo 'GitLab:      https://gitlab.${var.lab_domain}'",
      "echo 'Artifactory: https://artifactory.${var.lab_domain}'",
      "echo 'Warte 3-5 Min auf ersten Start von GitLab...'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
      host        = self.ipv4_address
    }
  }
}

resource "hcloud_firewall" "main" {
  name = "${var.server_name}-fw"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  apply_to {
    label_selector = "project=devops-central"
  }
}
