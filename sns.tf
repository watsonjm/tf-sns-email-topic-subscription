data "template_file" "aws_cf_sns_stack" {
  template = file("${path.module}/templates/cf_aws_sns_email_stack.json.tpl")
  vars = {
    sns_topic_name   = title(var.email_list_name)
    sns_display_name = "Email Notifications: ${title(var.email_list_name)}"
    sns_subscription_list = join(",", formatlist("{\"Endpoint\": \"%s\",\"Protocol\": \"%s\"}",
    var.email_list, "email"))
  }
}

resource "aws_cloudformation_stack" "tf_sns_topic" {
  name          = var.email_list_name
  template_body = data.template_file.aws_cf_sns_stack.rendered

  tags = merge(var.common_tags, { Name = "${var.name_tag}-snsStack-${lower(var.email_list_name)}" })
}

data "aws_sns_topic" "email_notifications" {
  name = title(var.email_list_name)
}