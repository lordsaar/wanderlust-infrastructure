# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

GCP infrastructure for the Wanderlust app, defined with Terraform. Provisions resources that support a containerized backend + frontend deployed to Cloud Run.

## Common Commands

```bash
# Authenticate (required before any terraform commands)
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID

# Standard workflow
terraform init
terraform plan
terraform apply

# Target a specific resource
terraform plan -target=google_sql_database_instance.wanderlust
terraform apply -target=google_secret_manager_secret.anthropic_api_key

# Validate and format
terraform validate
terraform fmt -recursive
```

## Architecture

The root module (`main.tf`) is the active configuration. The `modules/` and `environments/` directories exist as scaffolding for future modularization but are currently empty.

Deployed resources (tracked in `terraform.tfstate`):
- **Artifact Registry** (`wanderlust`) — Docker image store; GitHub Actions pushes images here
- **Cloud SQL** (`wanderlust-db`, PostgreSQL 16, `db-f1-micro`) — production database with backups enabled; `deletion_protection = false` intentionally (dev setup)
- **Secret Manager** — stores `anthropic-api-key`, `wanderlust-db-password`, `google-client-id`, `google-client-secret`, `auth-secret`

Cloud Run deployment is handled via CI/CD (not yet in this repo — noted as "Phase 4").

## Key Conventions

- **`terraform.tfvars` is gitignored** — copy from `terraform.tfvars.example` and fill in values locally. Never commit `*.tfvars` (except `.example`).
- **State files are gitignored** — `terraform.tfstate` and backups are local only; no remote backend is configured yet.
- Default region is `europe-west1`.
- The `google` provider is pinned to `~> 5.0`.
- Terraform v1.14+ required (root module declares `>= 1.0`).
