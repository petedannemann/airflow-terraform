resource "aws_db_instance" "this" {
  identifier                = "${var.name_prefix}-database"
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "9.6.6"
  instance_class            = "db.t2.micro"
  name                      = "airflow"
  username                  = "airflow"
  password                  = "${var.db_password}"
  storage_type              = "gp2"
  backup_retention_period   = 14
  multi_az                  = false
  publicly_accessible       = false
  apply_immediately         = true
  db_subnet_group_name      = "${aws_db_subnet_group.this.name}"
  final_snapshot_identifier = "${var.name_prefix}-database-final-snapshot-1"
  skip_final_snapshot       = false
  vpc_security_group_ids    = [ "${aws_security_group.airflow_database.id}"]
  port                      = "5432"
}

resource "aws_security_group" "airflow_database" {
  name        = "${var.name_prefix}-database"
  description = "Controlling traffic to and from airflows rds instance."
  vpc_id      = "${aws_vpc.this.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "airflow_database" {
  security_group_id = "${aws_security_group.airflow_database.id}"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"

  cidr_blocks = [
    "${aws_instance.airflow.private_ip}/32"
  ]
}