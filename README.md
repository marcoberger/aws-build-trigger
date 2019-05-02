# Triggering AWS CodePipeline builds from a GitHub monorepo

This is the repository that contains the sample code for the [codecentric blog](https://blog.codecentric.de) article [Triggering AWS CodePipeline builds from a GitHub monorepo](https://blog.codecentric.de/addThePathHere).


## Calling the module
```hcl
module "codebuild_webhook" {
  source = "terraform/modules/CodeBuild-WebHook"

  codebuild_project_name = "myCodeBuildProject"
  file_path_placeholders = ["team_A/frontend/.*", "team_A/backend/.*"]
  head_ref_placeholder   = "develop"
  webhookcli_prefix      = "myWebhook"
  is_enabled             = "${local.environment == "dev" ? true : false }"
}
```
