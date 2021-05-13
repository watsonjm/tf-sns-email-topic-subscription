locals {
  sns_sub_list = {
    "warnings" = var.warning_sns_subscription_email_list
    "errors"   = var.error_sns_subscription_email_list
    "all"      = concat(var.warning_sns_subscription_email_list, var.error_sns_subscription_email_list)
  }
  alert_warnings = {
    arn_list = [data.aws_sns_topic.email_notifications["warnings"].arn]
    arn      = data.aws_sns_topic.email_notifications["warnings"].arn
  }
  alert_errors = {
    arn_list = [data.aws_sns_topic.email_notifications["errors"].arn]
    arn = data.aws_sns_topic.email_notifications["errors"].arn
  }
  alert_all = {
    arn      = data.aws_sns_topic.email_notifications["all"].arn
    arn_list = [data.aws_sns_topic.email_notifications["all"].arn]
  }
}

data "template_file" "aws_cf_sns_stack" {
  for_each = local.sns_sub_list
  template = file("${path.module}/templates/cf_aws_sns_email_stack.json.tpl")
  vars = {
    sns_topic_name   = title(each.key)
    sns_display_name = "Email Notifications: ${title(each.key)}"
    sns_subscription_list = join(",", formatlist("{\"Endpoint\": \"%s\",\"Protocol\": \"%s\"}",
    each.value, "email"))
  }
}

resource "aws_cloudformation_stack" "tf_sns_topic" {
  for_each      = local.sns_sub_list
  name          = each.key
  template_body = data.template_file.aws_cf_sns_stack[each.key].rendered

  tags = merge(local.common_tags, { Name = "${local.name_tag}-snsStack-${lower(each.key)}" })
}

data "aws_sns_topic" "email_notifications" {
  for_each = toset(keys(aws_cloudformation_stack.tf_sns_topic))
  name     = title(each.key)
}