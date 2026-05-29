# Terraform Remote State Backend (empfohlen für produktive Nutzung)

# Standardmäßig speichert Terraform den State lokal (terraform.tfstate).
# Für mehrere Maschinen, CI/CD oder Teamarbeit empfehlen wir einen Remote Backend.

# ============================================
# Option 1: Hetzner Object Storage (S3-kompatibel)
# ============================================
# 1. Bucket in Hetzner Object Storage anlegen
# 2. Access Key + Secret Key erstellen
# 3. Diese Datei anpassen und auskommentieren

# terraform {
#   backend "s3" {
#     bucket                      = "devops-central-state"
#     key                         = "terraform.tfstate"
#     region                      = "eu-central-1"
#     endpoint                    = "https://fsn1.your-object-storage.com"   # z.B. fsn1.your-object-storage.com
#     access_key                  = var.s3_access_key
#     secret_key                  = var.s3_secret_key
#     skip_credentials_validation = true
#     skip_region_validation      = true
#     skip_metadata_api_check     = true
#     force_path_style            = true
#   }
# }

# ============================================
# Option 2: Terraform Cloud (einfach & kostenlos bis 500 Ressourcen)
# ============================================
# terraform {
#   cloud {
#     organization = "deine-organisation"
#     workspaces {
#       name = "devops-central"
#     }
#   }
# }

# Nach Änderung des Backends:
# terraform init -migrate-state
