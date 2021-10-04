# ELB with stickiness Example

The example launches a web server(multiples), installs nginx and basic tools, creates an ELB for instance. It also creates security groups for the ELB and EC2 instance. 

To run, configure your AWS provider as described in https://www.terraform.io/docs/providers/aws/index.html

This example assumes you have created a Key Pair. Visit
https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:sort=keyName
to create a key if you do not have one. 

### Set your AWS Credentials

```

export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_REGION=sa-east-1

```

### Create a tfvar


```variables.tfvars
aws_region = "sa-east-1"
key_name = "teste"
vpc_id = "vpc-xxxxxxxx"
subnet_id = "sb-xxxxx,sb-xxxxx"
instance_type = "t3a.xlarge"
ebs_root_size = "20"
ec2_ebs_volume_size = "150"
server_names = ["WSO2-01", "WSO2-02", "WSO2-03", "WSO2-04"]
environment  = "Staging"

```

### Run this example using:
    `terraform init`
    `terraform plan  -var-file=variables.tfvars`
    `terraform apply -var-file=variables.tfvars`

Wait a couple of minutes for the EC2 userdata to install nginx, and then type the ELB DNS Name from outputs in your browser and see the nginx welcome page

### Do you want multiples clusters?
If you wish to create more clusters, you can use `terraform workspace` and also create more tfvars file, one for each environment!

