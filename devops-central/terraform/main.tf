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

  # Automatisches Setup nach dem Boot
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "echo '=== DevOps Central Setup ==='",
      "git clone https://github.com/commana/ai-experiments.git /opt/devops-central || true",
      "echo 'Repo geklont nach /opt/devops-central'",
      "echo 'Nächster Schritt: SSH zum Server und ./scripts/bootstrap.sh ausführen'"
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
