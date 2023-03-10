locals {
  # Set scm_integration with : 
  #  - the content of github_integration if it is not null (+ the type = "github")
  #  - the content of gitlab_integration if it is not null (+ the type = "gitlab")
  #  - an empty map otherwise
  scm_integration = (var.github_integration != null
    ? { github = var.github_integration }
    : (var.gitlab_integration != null
      ? { gitlab = var.gitlab_integration }
      : {}
    )
  )
}

data "scalingo_scm_integration" "scm_integration" {
  for_each = local.scm_integration

  scm_type = each.key
}

resource "scalingo_scm_repo_link" "scm_repo_link" {
  for_each = local.scm_integration

  app    = scalingo_app.app.name
  source = each.value.repo_url
  auth_integration_uuid = (each.value.integration_uuid != null
    ? each.value.integration_uuid
    : data.scalingo_scm_integration.scm_integration[each.key].id
  )

  auto_deploy_enabled          = each.value.auto_deploy_enabled
  branch                       = each.value.branch
  delete_on_close_enabled      = each.value.delete_on_close_enabled
  delete_stale_enabled         = each.value.delete_stale_enabled
  deploy_review_apps_enabled   = each.value.deploy_review_apps_enabled
  hours_before_delete_on_close = each.value.hours_before_delete_on_close
  hours_before_delete_stale    = each.value.hours_before_delete_stale
  # will be available in v2.1.0 :
  # automatic_creation_from_forks_allowed = each.value.automatic_creation_from_forks_allowed
}
