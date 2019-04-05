terraform {
  backend "s3" {
    bucket = "airflow-terraform"
    key    = "airflow-terraform-state"
    region = "us-east-1"
  }
}