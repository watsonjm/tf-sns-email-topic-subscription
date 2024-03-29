{
 "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "SNSTopic": {
      "Type": "AWS::SNS::Topic",
      "Properties": {
        "TopicName": "${sns_topic_name}",
        "DisplayName": "${sns_display_name}",
        "KmsMasterKeyId" : "${kms_key_id}",
        "Subscription": [
          ${sns_subscription_list}
        ]
      }
    }
  }
}