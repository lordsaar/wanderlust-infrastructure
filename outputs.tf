output "artifact_registry_url" {
  description = "Artifact Registry URL for Docker images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/wanderlust"
}

output "db_instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.wanderlust.name
}
