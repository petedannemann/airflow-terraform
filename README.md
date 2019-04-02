# Airflow Terraform

## Goal

Easily provision resources on AWS for a highly scalable and secure airflow environment.

## Overview

- Terraform is used to provision resources in a VPC.
- Terraform's state is stored in a private S3 bucket.
- Redis, PostgreSQL, and Airflow's services are deployed on an EC2 instance.
- AWS Secrets Manager is used to securely feed environment variables such as airflow's fernet key into the EC2 instance.

## Requirements

- AWS Account
- Terraform

## Setup

- [Create an EC2 key pair or use an existing one](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-key-pair.html)
  `aws ec2 create-key-pair --key-name MyKeyPair`
- [Create a KMS](https://docs.aws.amazon.com/cli/latest/reference/kms/create-key.html) for encrypting in Airflow's database
  `aws kms create-key`
- Create a airflow fernet key with AWS Secrets Manager using the KMS key you created

```bash
aws secretsmanager create-secret --name airflow-fernet-key \
    --description "Airflow fernet key for encryption in the metadata database" \
    --kms-key-id "id-of-my-key"\
    --secret-string "my-fernet-key"
```

- Create an S3 bucket to hold your backend
  `aws s3api create-bucket --bucket airflow-backend --region us-east1 --acl private`

## Commands

- _See a plan of resources_ `terraform plan`
- _Provision resources_ `terraform apply`
- _Destroy resources_ `terraform destroy`
