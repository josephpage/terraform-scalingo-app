resource "scalingo_collaborator" "collaborators" {
  for_each = toset(var.additionnal_collaborators)

  app   = scalingo_app.app.id
  email = sensitive(each.key)
}
