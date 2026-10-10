output "website_url" {
  description = "URL pública de la aplicación"
  value       = "http://${aws_instance.web.public_ip}"
}