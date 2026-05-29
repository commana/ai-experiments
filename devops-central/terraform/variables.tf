variable "hcloud_token" {
  description = "Hetzner Cloud API Token (mit Write-Rechten)"
  type        = string
  sensitive   = true
}

variable "server_name" {
  description = "Name des Servers"
  type        = string
  default     = "devops-lab"
}

variable "server_type" {
  description = "Hetzner Server Typ (cpx42 = 8vCPU/16GB gut für Start)"
  type        = string
  default     = "cpx42"
}

variable "location" {
  description = "Hetzner Location (nbg1 = Nürnberg)"
  type        = string
  default     = "nbg1"
}

variable "ssh_public_key" {
  description = "Dein SSH Public Key (Inhalt von id_ed25519.pub)"
  type        = string
}

variable "lab_domain" {
  description = "Deine Domain (z.B. example.com) - Subdomains gitlab. und artifactory."
  type        = string
  default     = "example.com"
}

variable "admin_email" {
  description = "E-Mail für Let's Encrypt (Caddy)"
  type        = string
  default     = "admin@example.com"
}

variable "gitlab_root_password" {
  description = "Initiales Root-Passwort für GitLab (muss stark sein!)"
  type        = string
  default     = "ChangeMeStrong123!"
  sensitive   = true
}
