#!/bin/bash

echo "Creating Lambda Function with Full Access role "
#code is retrieved from s3 bucket
aws lambda create-function --function-name resize-img --region us-east-1 --runtime python3.7 --role arn:aws:iam::488599217855:role/FullAccess --timeout 300 --memory-size 512 --handler lambda_function.lambda_handler --code S3Bucket="resize-assign",S3Key="code.zip",S3ObjectVersion="Latest Version"

echo "Getting ARN for the lambda function"

arn=$(aws lambda get-function-configuration --function-name pe-rmm-copylambda --region us-east-1 --query '{FunctionArn:FunctionArn}' --output text)
echo $arn

echo "Adding events json file for S3 trigger"

#bucekt austin-practice is trigger
aws lambda add-permission \
--function-name resize-img \
--region "us-east-1" \
--statement-id "1" \
--action "lambda:InvokeFunction" \
--principal s3.amazonaws.com \
--source-arn arn:aws:s3:::austin-practise 
echo "Lambda function created..\nAdding Permissions"

echo "{
  \"LambdaFunctionConfigurations\": [
    {
      \"LambdaFunctionArn\":"\""$arn"\"",
      \"Events\": [\"s3:ObjectCreated:*\"]
    }]}" > events.json

#Adding permissions for s3 trigger
echo "Permission added\nAdding S3 trigger..."
aws s3api put-bucket-notification-configuration \
--bucket austin-practise \
--notification-configuration file://events.json
