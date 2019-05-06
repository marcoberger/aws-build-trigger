# Use AWS CodeBuild to trigger build pipeline

This is the repository that contains the sample code for the [codecentric blog](https://blog.codecentric.de) article [Use AWS CodeBuild to trigger build pipeline](https://blog.codecentric.de/en/2019/05/codebuild-trigger-pipeline/).


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
