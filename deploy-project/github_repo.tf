provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

resource "github_repository" "example" {
  name        = "DemoRepo"
  description = "My awesome repo"

  visibility = "public"
  has_issues = true

  #This property is required to make a repo from a template (comment it if isn't necessary)
  template {
    owner      = var.template_owner
    repository = var.template_repository
  }
}
