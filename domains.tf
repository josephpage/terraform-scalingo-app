resource "scalingo_domain" "canonical_domain" {
  count = var.domain != null ? 1 : 0

  app         = scalingo_app.app.name
  canonical   = true
  common_name = var.domain

  # Attributes not supported by the provider on v2.0 :
  # tlscert - optional: SSL Certificate you want to associate with the domain
  # tlskey - optional: Private key used to create the SSL certificate
}

resource "scalingo_domain" "domain_aliases" {
  for_each = toset(var.domain_aliases)

  app         = scalingo_app.app.name
  canonical   = false
  common_name = each.key
}
