resource "aws_security_group" "bastion" {
  name = "${var.name}"
  vpc_id = "${var.vpc_id}"
  description = "Bastion security settings"

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
    Service     = "bastion"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "access" {
  name        = "${var.name}-access"
  description = "Bastion passthrough access security settings"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
    Service     = "bastion"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.bastion.id}"]
  }
}

module "ami" {
  source        = "github.com/terraform-community-modules/tf_aws_ubuntu_ami/ebs"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  distribution  = "trusty"
}

resource "aws_instance" "bastion" {
  ami                    = "${module.ami.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.ec2_key_name}"
  subnet_id              = "${element(split(",", var.subnet_ids), count.index)}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
    Service     = "bastion"
  }

  lifecycle {
    create_before_destroy = true
  }
}
