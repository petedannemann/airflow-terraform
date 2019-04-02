resource "aws_s3_bucket" "terraform-backend" {
  bucket = "${var.name_prefix}-terraform"
  acl = "private"

  tags {
    Airflow = "Airflow terraform backend"
  }
}