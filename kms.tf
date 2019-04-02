resource "aws_kms_key" "airflow-fernet-key" {
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "airflow-fernet-key" {
  name = "alias/airflow-fernet-key"
  target_key_id = "${aws_kms_key.airflow-fernet-key.key_id}"
}