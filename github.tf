provider "github" {
}

data "github_repository" "repo" {
    full_name = "nguyentan11/fsoft-lab1"
}

resource "github_repository_environment" "Mike_environment" {
    repository = data.github_repository.repo.name
    environment = "test"
}

resource "github_action_environment_secret" "test_secret" {
    repository = data.github_repository.repo.name
    environment = github_repository_environment.Mike_environment.environment
    secret_name = "ansible inventory"
    encrypt_valua = "%s"
}