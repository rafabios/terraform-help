# These values overwrites the variables.tf, but you need to invoke terrafom apply with -tfvar=variables.tfvars

aws_region          = "sa-east-1"
key_name            = "Develop-Key"
vpc_id              = "vpc-xxxxxxxx"
subnet_id           = "sb-xxxxx,sb-xxxxx"
instance_type       = "t3a.micro"
ebs_root_size       = "10"
ec2_ebs_volume_size = "100"
server_names        = ["web-01", "web-02", "web-03", "web-04"]
environment         = "Develop"
