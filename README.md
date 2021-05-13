# tf-sns-email-topic-subscription
Creates an AWS SNS topic and email subscription list via CloudFormation

### Variables
- email_list_name = whatever you want to name the email list (e.g. errors or warnings)
- email_list = a list of email addresses to send emails to
- common_tags = whatever tags you're using on every resource
- name_tag = prefix for the 'Name' tag

### Outputs
- the AWS SNS topic information
    - arn
    - id
    - name


## Example
```
error_sns_subscription_email_list = ["jwatson@ksmconsulting.com"]

locals {
  common_tags = {
    repo        = var.gitrepo
    environment = var.environment
  }
  name_tag = "${var.environment}-${var.product_name}"
}


module "email_error_alerts" {
  source          = "github.com/watsonjm/tf-sns-email-topic-subscription?ref=v1.0"
  email_list_name = "errors"
  email_list      = var.error_sns_subscription_email_list
  common_tags     = local.common_tags
  name_tag        = local.name_tag
}
```