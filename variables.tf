variable "email_list_name" {
  type        = string
  description = "name of your email list"
}
variable "email_list" {
  type        = list(string)
  description = "list of emails for your list"
}
variable "common_tags" {
  type        = map(any)
  default     = null
  description = "map of tags on each resource"
}
variable "name_tag" {
  type        = string
  default     = null
  description = "Name tag prefix used in other resources for consistency"
}
variable "email_display_name" {
  type        = string
  default     = null
  description = "Display name used for email notifications."
}
variable "kms_key_id" {
  type        = string
  default     = "alias/aws/sns"
  description = "KMS key ID for encrypting SNS topics. Will use default key if no custom key is present."
}