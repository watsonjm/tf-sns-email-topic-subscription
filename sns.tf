data "template_file" "aws_cf_sns_stack" {
  template = file("${path.module}/templates/cf_aws_sns_email_stack.json.tpl")
  vars = {
    sns_topic_name        = var.email_list_name
    sns_display_name      = var.email_display_name == null ? "Email Notifications: ${var.email_list_name}" : var.email_display_name
    sns_subscription_list = join(",", formatlist("{\"Endpoint\": \"%s\",\"Protocol\": \"%s\"}", var.email_list, "email"))
    kms_key_id            = var.kms_key_id
  }
}

resource "aws_cloudformation_stack" "tf_sns_topic" {
  name          = var.email_list_name
  template_body = data.template_file.aws_cf_sns_stack.rendered

  lifecycle {
    ignore_changes = [tags]
  }

  tags = merge(var.common_tags, { Name = "${var.email_list_name}-snsStack" })
}

data "aws_sns_topic" "email_notifications" {
  name = aws_cloudformation_stack.tf_sns_topic.name
}