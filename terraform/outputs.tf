output "web01_ip" {
  description = "IP address of web-01"
  value       = var.web01_ip
}

output "db01_ip" {
  description = "IP address of db-01"
  value       = var.db01_ip
}

output "monitor01_ip" {
  description = "IP address of monitor-01"
  value       = var.monitor01_ip
}

output "web_app_url" {
  description = "URL of the Flask application"
  value       = "http://${var.web01_ip}:5000"
}
