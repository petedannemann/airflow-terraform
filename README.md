# Airflow Terraform

## Goal

Easily provision resources on AWS for a highly scalable and secure airflow environment.

## Overview

- Terraform is used to provision resources in a VPC.
- Airflow's services are deployed on an EC2 instance.
- The Airflow metadata database is deployed on RDS (Postgres).
- The Airflow message broker is deployed on Elastic Cache (Redis).
- AWS Secrets Manager is used to securely feed environment variables such as airflow's fernet key into the EC2 instance.

## Requirements

- AWS Account
- Terraform

## Setup

- [Create an EC2 key pair or use an existing one](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-key-pair.html)
  `aws ec2 create-key-pair --key-name MyKeyPair`

## Terraform Commands

**First enter the Terraform directory** `cd terraform`

- _See a plan of resources_ `terraform plan`
- _Provision resources_ `terraform apply`
- _Destroy resources_ `terraform destroy`
