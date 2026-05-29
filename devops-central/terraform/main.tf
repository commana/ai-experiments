resource "hcloud_ssh_key" "main" {
  name       = "${var.server_name}-key"
  public_key = var.ssh_public_key
}

# Cloud Volume für persistente Daten (GitLab + Artifactory)
resource "hcloud_volume" "data" {
  name      = var.volume_name
  size      = var.volume_size
  location  = var.location
  format    = "ext4"
  labels = {
    project = "devops-central"
  }
}

resource "hcloud_volume_attachment" "data" {
  volume_id = hcloud_volume.data.id
  server_id = hcloud_server.main.id
  automount = false
}

resource "hcloud_server" "main" {
  name        = var.server_name
  server_type = var.server_type
  image       = "ubuntu-24.04"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.main.name]

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    volume_name = var.volume_name
  })

  labels = {
    project = "devops-central"
    purpose = "on-demand-lab"
  }

  depends_on = [hcloud_volume_attachment.data]

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
      "docker compose pull",
      "docker compose up -d",
      "echo '✅ Stack automatisch gestartet!'"
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
