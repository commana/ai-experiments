# =====================================================
# Terraform Remote State Backend - Hetzner Object Storage
# =====================================================

# Hetzner Object Storage ist S3-kompatibel und eignet sich perfekt
# als Terraform State Backend (günstig + DSGVO-konform).

# --- SCHRITT 1: Bucket anlegen ---
# 1. Gehe zu https://console.hetzner.cloud/
# 2. Object Storage → "Create Bucket"
# 3. Bucket Name z.B.: devops-central-terraform-state
# 4. Location: z.B. fsn1 (Nürnberg)

# --- SCHRITT 2: Access Keys erstellen ---
# 1. Im selben Bereich "Access Keys" → "Generate Access Key"
# 2. Key + Secret kopieren

# --- SCHRITT 3: Diese Datei aktivieren ---
# Kommentiere den folgenden Block ein und passe die Werte an.

# terraform {
#   backend "s3" {
#     bucket                      = "devops-central-terraform-state"   # dein Bucket-Name
#     key                         = "devops-central/terraform.tfstate"  # Pfad im Bucket
#     region                      = "eu-central-1"                        # beliebig
#     endpoint                    = "https://fsn1.your-object-storage.com" # dein Location
#     access_key                  = var.s3_access_key
#     secret_key                  = var.s3_secret_key
#     skip_credentials_validation = true
#     skip_region_validation      = true
#     skip_metadata_api_check     = true
#     force_path_style            = true
#   }
# }

# --- SCHRITT 4: State migrieren ---
# terraform init -migrate-state

# Hinweis: Hetzner Object Storage unterstützt kein natives State Locking.
# Für Locking empfehlen wir Terraform Cloud (kostenlos bis 500 Ressourcen).
