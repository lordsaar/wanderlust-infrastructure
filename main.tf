terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Artifact Registry — stores Docker images
resource "google_artifact_registry_repository" "wanderlust" {
  location      = var.region
  repository_id = "wanderlust"
  description   = "Wanderlust Docker images"
  format        = "DOCKER"
}

# Cloud SQL — PostgreSQL database
resource "google_sql_database_instance" "wanderlust" {
  name             = "wanderlust-db"
  database_version = "POSTGRES_16"
  region           = var.region

  settings {
    tier = "db-f1-micro"  # smallest instance, fine for dev

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false  # allow destroy for dev
}

resource "google_sql_database" "wanderlust" {
  name     = "wanderlust"
  instance = google_sql_database_instance.wanderlust.name
}

resource "google_sql_user" "wanderlust" {
  name     = "wanderlust"
  instance = google_sql_database_instance.wanderlust.name
  password = var.db_password
}

# Secret Manager — store Anthropic API key
resource "google_secret_manager_secret" "anthropic_api_key" {
  secret_id = "anthropic-api-key"

  replication {
    auto {}
  }
}

# Cloud Run will be deployed via CI/CD pipeline in Phase 4