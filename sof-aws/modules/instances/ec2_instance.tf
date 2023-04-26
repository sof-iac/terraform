data "aws_vpc" "vpc" {
  filter {
    name  = "tag:Name"
    values = ["VPC_SOF"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["AWS_SERVICO"] 
  }
}
data "aws_security_group" "security_group" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name  = "group-name"
    values = ["sg_shiny_server"]
  }

}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "AWS_PSHI01"

  ami                    = "ami-0b7af114fb404cd23"
  instance_type          = "t3.small"
  key_name               = "user_svc_aws_shiny_server"
  ebs_optimized          = true
  vpc_security_group_ids = [data.aws_security_group.security_group.id]
  subnet_id              = data.aws_subnets.subnets.ids[0]

  tags = {
    Environment = "sof-aws-prod"
    Terraform   = "true"
  }
}