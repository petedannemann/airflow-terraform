output "ip" {
   value = "${aws_eip.airflow.public_ip}"
}