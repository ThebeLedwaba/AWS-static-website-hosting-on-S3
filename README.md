# AWS Beginner Project: Static Website Hosting

This project demonstrates how to host a static website on AWS using S3 and CloudFront.

## Project Structure

- `index.html`: Main website page
- `error.html`: Custom 404 error page
- `styles/main.css`: CSS stylesheet
- `images/`: Contains website images
- `deploy-script.sh`: Deployment automation script

## Deployment Steps

1. Create an S3 bucket with public access
2. Upload all files to the bucket
3. Enable static website hosting in bucket properties
4. Set `index.html` as index document and `error.html` as error document
5. Create a CloudFront distribution pointing to the S3 bucket
6. Wait for deployment and access your website via the CloudFront URL

## Automated Deployment

Run the `deploy-script.sh` after configuring AWS CLI with your credentials.
