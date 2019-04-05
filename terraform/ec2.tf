resource "aws_instance" "airflow" {
  key_name                    = "${var.key}"
  associate_public_ip_address = true
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(aws_subnet.this.*.id, count.index)}"
  vpc_security_group_ids      = [ "${aws_security_group.airflow_ec2.id}", ]

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