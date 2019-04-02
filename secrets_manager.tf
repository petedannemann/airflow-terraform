data "aws_secretsmanager_secret" "airflow-fernet-key" {
  name = "airflow-fernet-key"
}