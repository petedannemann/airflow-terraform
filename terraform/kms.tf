resource "aws_kms_key" "airflow-fernet-key" {
  description             = "Encrypts data in airflow's database"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "airflow-fernet-key" {
  name          = "alias/airflow-fernet-key"
  target_key_id = "${aws_kms_key.airflow-fernet-key.key_id}"
}

resource "aws_secretsmanager_secret" "airflow-fernet" {
  name       = "airflow-fernet-encryption-key"
  kms_key_id = "${aws_kms_key.airflow-fernet-key.arn}"
}

resource "aws_secretsmanager_secret_version" "airflow-fernet" {
  secret_id     = "${aws_secretsmanager_secret.airflow-fernet.id}"
  secret_string = "${var.airflow_fernet_secret_string}"
}
