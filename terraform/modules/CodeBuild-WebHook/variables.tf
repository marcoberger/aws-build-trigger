variable "codebuild_project_name" {
  description = "The name of the CodeBuild Project, which uses the webhook"
}

variable "file_path_placeholders" {
  type        = "list"
  description = "A list of webhook regular expressions for file path filtering"
}

variable "head_ref_placeholder" {
  description = "The webhook regular expression for branch name filtering"
}

variable "webhookcli_prefix" {
  description = "A prefix for the webhook CLI json file"
}

variable "is_enabled" {
  default     = true
  description = "Defines if the resources in this module should be executed"
}
