
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "sa-east-1"
}

# SSH AWS Key Name (should be created already)
variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

# Vpc id 
variable "vpc_id" {
  default = "vpc-xxxxxx"
}

# Subnets
variable "subnet_id" {
  default = "sg-aa821ee2q,sg-aa821ee2q"
}


# Instance Type
variable "instance_type" {
  default = "t3a.xlarge"
}

# EBS root disk size
variable "ebs_root_size" {
  default = "20"
}

# EBS second disk size
variable "ec2_ebs_volume_size" {
  default = "100"
}

# Server names (list of instances to be created)
variable "server_names" {
  type    = list(any)
  default = ["WEBSERVER-01", "WEBSERVER-02", "WEBSERVER-03", "WEBSERVER-04"]
}

# Tags - environment
variable "environment" {
  default = "Staging"
}

# ubuntu-trusty-14.04 (x64)  - base image
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-7f675e4f"
    "sa-east-1" = "ami-79f54964"
  }
}
