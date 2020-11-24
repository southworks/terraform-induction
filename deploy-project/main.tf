provider "azuredevops" {
  # Specify the Azure DevOps provider version to use.
  version = ">= 0.0.1"

  # Remember to specify the org service url and personal access token details below
  org_service_url       = var.devops_organization_url
  personal_access_token = var.devops_access_token
}

resource "azuredevops_project" "terraform_ado_project" {
  project_name       = "terraform-demo"
  description        = "description"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
  # Enable or disable the DevOps fetures below (enabled / disabled)
  features = {
    "boards"       = "enabled"
    "repositories" = "enabled"
    "pipelines"    = "enabled"
    "testplans"    = "enabled"
    "artifacts"    = "enabled"
  }
}
