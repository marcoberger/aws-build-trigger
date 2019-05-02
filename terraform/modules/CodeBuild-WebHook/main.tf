locals {
  enable                         = "${var.is_enabled == "true" ? 1 : 0}"
  webhookcli_base_json_file_path = "${path.module}/assets/base_webhookcli.tmpl"
  webhookcli_data_json_file_path = "${path.module}/assets/data_webhookcli.tmpl"
  webhookcli_json_file_path      = "${path.module}/assets/${var.webhookcli_prefix}-webhookcli.json"
}

resource "aws_codebuild_webhook" "default" {
  count        = "${local.enable}"
  project_name = "${var.codebuild_project_name}"
}

data "null_data_source" "template_base_webhook_json_file" {
  inputs {
    filename = "${local.webhookcli_base_json_file_path}"
  }
}

data "null_data_source" "template_data_webhook_json_file" {
  inputs {
    filename = "${local.webhookcli_data_json_file_path}"
  }
}

data "null_data_source" "webhook_json_file" {
  inputs {
    filename = "${local.webhookcli_json_file_path}"
  }
}

data "template_file" "template_webhook_data_json" {
  template = "${file("${data.null_data_source.template_data_webhook_json_file.outputs.filename}")}"
  count    = "${length(var.file_path_placeholders)}"

  vars {
    file_path_placeholder = "${var.file_path_placeholders[count.index]}"
    head_ref_placeholder  = "refs/heads/${var.head_ref_placeholder}"
  }
}

data "template_file" "template_webhook_json_file" {
  template = "${file("${data.null_data_source.template_base_webhook_json_file.outputs.filename}")}"

  vars {
    project_name = "${var.codebuild_project_name}"
    filter_data  = "${join(",", data.template_file.template_webhook_data_json.*.rendered)}"
  }
}

resource "local_file" "rendered_update_webhook_json_file" {
  count = "${local.enable}"

  content  = "${data.template_file.template_webhook_json_file.rendered}"
  filename = "${data.null_data_source.webhook_json_file.outputs.filename}"
}

resource "null_resource" "update-webhook" {
  count = "${local.enable}"

  depends_on = [
    "data.template_file.template_webhook_json_file",
    "local_file.rendered_update_webhook_json_file",
  ]

  triggers = {
    policy_sha1 = "${sha1("${data.template_file.template_webhook_json_file.rendered}")}"
  }

  provisioner "local-exec" {
    command = "aws codebuild update-webhook --cli-input-json file://${local.webhookcli_json_file_path}"
  }
}
