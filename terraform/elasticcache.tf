resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.name_prefix}"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name = "${aws_elasticache_subnet_group.this.name}"
  security_group_ids   = ["${aws_security_group.elasticcache.id}"]

  tags {
      Name = "${var.name_prefix}-elasticcache"
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name_prefix}-elasticcache"
  subnet_ids = ["${aws_subnet.this.*.id}"]
}

resource "aws_security_group" "elasticcache" {
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

resource "aws_security_group_rule" "elasticcache" {
  security_group_id = "${aws_security_group.elasticcache.id}"
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"

  cidr_blocks = [
    "${aws_instance.airflow.private_ip}/32"
  ]
}