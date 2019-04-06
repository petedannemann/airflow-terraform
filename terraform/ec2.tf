resource "aws_instance" "airflow" {
  key_name                    = "${var.key}"
  associate_public_ip_address = true
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(aws_subnet.this.*.id, count.index)}"
  vpc_security_group_ids      = [ "${aws_security_group.airflow_ec2.id}", ]
  iam_instance_profile        = "${aws_iam_instance_profile.this.name}"

  root_block_device {
    volume_size = 16
  }

  tags {
    Name = "${var.name_prefix}"
  }
}

resource "aws_eip" "airflow" {
  instance = "${aws_instance.airflow.id}"
}

resource "aws_security_group" "airflow_ec2" {
  name        = "${var.name_prefix}-sg"
  description = "Allows inbound SSH traffic from your IP"
  vpc_id      = "${aws_vpc.this.id}"

  tags {
    Name = "${var.name_prefix} security group"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "${var.my_ip_address}", ]
  security_group_id = "${aws_security_group.airflow_ec2.id}"
}

resource "aws_security_group_rule" "web" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [ "${var.my_ip_address}", ]
  security_group_id = "${aws_security_group.airflow_ec2.id}"
}

resource "aws_security_group_rule" "internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.airflow_ec2.id}"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-instance-profile"
  role = "${aws_iam_role.this.name}"
}


resource "aws_iam_role" "this" {
  name        = "${var.name_prefix}-iam-role"
  description = "Gives access to AWS Secrets Manager"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "this" {
  name        = "test-policy"
  description = "A test policy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "${aws_secretsmanager_secret.airflow-fernet.arn}"
    }
}
POLICY
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${aws_iam_policy.this.arn}"
}