output "url" {
  description = "Base URL (https://*) to access the application"
  value = scalingo_app.app.url
}

output "git_url" {
  description = "Hostname to use to deploy code with Git + SSH"
  value = scalingo_app.app.git_url
}
