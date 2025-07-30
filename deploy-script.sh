#!/bin/bash

# AWS S3 Static Website Deployment Script
# Ensure AWS CLI is configured with proper credentials before running

# Variables
BUCKET_NAME="my-aws-beginner-website-$(date +%s)"
REGION="us-east-1"
WEBSITE_FILES="./*"

# Create S3 bucket
echo "Creating S3 bucket: $BUCKET_NAME"
aws s3 mb s3://$BUCKET_NAME --region $REGION

# Configure bucket for static website hosting
echo "Configuring static website hosting"
aws s3 website s3://$BUCKET_NAME --index-document index.html --error-document error.html

# Upload files
echo "Uploading files to S3"
aws s3 sync . s3://$BUCKET_NAME --exclude "deploy-script.sh" --exclude "README.md"

# Set bucket policy for public access
echo "Setting bucket policy for public access"
cat > policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::$BUCKET_NAME/*"
            ]
        }
    ]
}
EOF

aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://policy.json
rm policy.json

# Create CloudFront distribution (simplified)
echo "Creating CloudFront distribution (this may take a few minutes)"
DISTRIBUTION_ID=$(aws cloudfront create-distribution --origin-domain-name $BUCKET_NAME.s3-website-$REGION.amazonaws.com --default-root-object index.html --query 'Distribution.Id' --output text)

echo "Deployment complete!"
echo "S3 Website URL: http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com"
echo "CloudFront distribution created with ID: $DISTRIBUTION_ID"
echo "Note: CloudFront may take 10-15 minutes to deploy"
