provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "allow_factorio" {
  name        = "factorio_sg"
  description = "Allow inbound traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 27015
    to_port     = 27015
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 34197
    to_port         = 34197
    protocol        = "udp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "factorio_sg"
  }
}


resource "aws_s3_bucket" "factorio_backups" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  tags {
    Name = "${var.s3_bucket_name}"
  }
}

resource "aws_iam_role" "allow_s3_access" {
  name = "factorio-allow-s3-access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF

}

resource "aws_iam_policy" "allow_s3_access" {
  name        = "factorio-allow-s3-access"
  path        = "/"
  description = "Allow all S3 actions on factorio bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.factorio_backups.arn}",
        "${aws_s3_bucket.factorio_backups.arn}/**"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "allow_s3_access" {
    role       = "${aws_iam_role.allow_s3_access.name}"
    policy_arn = "${aws_iam_policy.allow_s3_access.arn}"
}

resource "aws_iam_instance_profile" "factorio" {
  name  = "factorio"
  role = "${aws_iam_role.allow_s3_access.name}"
}

data "template_file" "factorio_init" {
  template = "${file("init.tpl")}"

  vars {
    hostname = "factorio"
    dns_domain = "${var.dns_domain}"
  }
}

resource "aws_spot_instance_request" "instance" {
  ami           = "${var.ami_id}"
  spot_price    = "${var.spot_price}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  key_name      = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_factorio.id}", "sg-335cc94b"]
  iam_instance_profile = "${aws_iam_instance_profile.factorio.name}"

  user_data = "${data.template_file.factorio_init.rendered}"
  associate_public_ip_address = true

  tags {
    Name = "factorio"
  }
}
