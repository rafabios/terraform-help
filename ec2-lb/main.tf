# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "WEB SecurityGroup"
  description = "Used in the terraform"
  vpc_id      = var.vpc_id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our elb security group to access
# the ELB over HTTP
resource "aws_security_group" "elb" {
  name        = "elb_sg"
  description = "Used in the terraform"

  vpc_id = var.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_elb" "web" {
  name = "wso2-elb"

  # The same availability zone as our instance
  subnets = ["${var.subnet_id}"]

  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  #instances                   = ["${aws_instance.web.id}"] # [count.index]
  instances                   = ["aws_instance.web[count.index].id"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_lb_cookie_stickiness_policy" "default" {
  name                     = "lbpolicy"
  load_balancer            = aws_elb.web.id
  lb_port                  = 80
  cookie_expiration_period = 600
}


resource "aws_lb_cookie_stickiness_policy" "default2" {
  name                     = "lbpolicy"
  load_balancer            = aws_elb.web.id
  lb_port                  = 8080
  cookie_expiration_period = 600
}

resource "aws_instance" "web" {
  instance_type = var.instance_type
  ami           = lookup(var.aws_amis, var.aws_region)
  key_name      = var.key_name
  count         = length(var.server_names)
  root_block_device {
    volume_size = var.ebs_root_size
  }
  tags = {
    Name       = "${var.server_names[count.index]}"
    ServerRole = "WSO2"
    Env        = "${var.environment}"
  }
}


# Create EBS volume
resource "aws_ebs_volume" "ebs_volume" {
  count             = length(var.server_names)
  availability_zone = aws_instance.web.*.availability_zone[count.index]
  size              = var.ec2_ebs_volume_size
}

# Attach EBS Volume
resource "aws_volume_attachment" "volume_attachment" {
  count       = length(var.server_names)
  device_name = var.server_names[count.index]
  volume_id   = aws_ebs_volume.ebs_volume.*.id[count.index]
  instance_id = "aws_instance.web[count.index].id"
}
