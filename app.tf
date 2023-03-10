data "scalingo_stack" "stack" {
  name = var.stack
}

resource "scalingo_app" "app" {
  name = var.name

  environment = var.environment

  stack_id    = data.scalingo_stack.stack.id
  force_https = !var.authorize_unsecure_http
}

resource "scalingo_container_type" "containers" {
  for_each = var.containers

  app    = scalingo_app.app.name
  name   = each.key
  amount = each.value.amount
  size   = each.value.size
}

# auto scaler
resource "scalingo_autoscaler" "autoscalers" {
  for_each = { for k, v in var.containers : k => v if v.autoscaler != null }

  app            = scalingo_app.app.name
  container_type = each.key
  metric         = each.value.autoscaler.metric
  target         = each.value.autoscaler.target
  min_containers = each.value.autoscaler.min_containers
  max_containers = each.value.autoscaler.max_containers
}
