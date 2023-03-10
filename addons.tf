resource "scalingo_addon" "addons" {
  for_each = { for index, addon in var.addons : addon.provider => addon }

  app               = scalingo_app.app.name
  provider_id       = each.value.provider
  plan              = each.value.plan
  database_features = each.value.database_features
}
