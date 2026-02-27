# Wanderlust Infrastructure

Google Cloud Platform infrastructure for Wanderlust, defined as code using Terraform.

## Resources

| Resource | Type | Purpose |
|----------|------|---------|
| `wanderlust` | Artifact Registry | Docker image repository |
| `wanderlust-db` | Cloud SQL (PostgreSQL 16) | Production database |
| `anthropic-api-key` | Secret Manager | Anthropic API key |
| `wanderlust-db-password` | Secret Manager | Database password |
| `google-client-id` | Secret Manager | Google OAuth client ID |
| `google-client-secret` | Secret Manager | Google OAuth client secret |
| `auth-secret` | Secret Manager | Auth.js secret |

## Architecture
```
GitHub Actions
      ↓
Artifact Registry (Docker images)
      ↓
Cloud Run (Backend + Frontend)
      ↓
Cloud SQL (PostgreSQL)
      ↑
Secret Manager (all secrets)
```

## Prerequisites

- Google Cloud SDK
- Terraform v1.14+
- GCP project with billing enabled

## Setup

1. Authenticate with GCP:
```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

2. Copy `terraform.tfvars.example` to `terraform.tfvars`:
```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Fill in your values in `terraform.tfvars`

4. Initialize and apply:
```bash
terraform init
terraform plan
terraform apply
```

## CI/CD Service Account

The `github-actions` service account has the following roles:
- `artifactregistry.writer` — push Docker images
- `run.admin` — deploy to Cloud Run
- `iam.serviceAccountUser` — act as service account
- `secretmanager.secretAccessor` — read secrets

## Costs

Estimated monthly costs for this project:
- Cloud SQL (db-f1-micro): ~€15-20
- Cloud Run: ~€0 (free tier covers low traffic)
- Artifact Registry: ~€0 (free tier)
- Secret Manager: ~€0 (free tier)
