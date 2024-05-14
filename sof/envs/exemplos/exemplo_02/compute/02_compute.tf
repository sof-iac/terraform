
data "aws_vpc" "vpc" {
  filter {
    name  = "tag:Name"
    values = ["VPC_TESTE"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["Teste-Servico"] # insert values here
  }
}
data "aws_security_group" "security_group" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name  = "group-name"
    values = ["default"]
  }

}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "tf-teste-instance"

  ami                    = "ami-05240a8eacac22db2"
  instance_type          = "t3.small"
  key_name               = "tf-teste"
  monitoring             = true
  vpc_security_group_ids = [data.aws_security_group.security_group.id]
  subnet_id              = data.aws_subnets.subnets.ids[0]

  tags = {
    Terraform   = "true"
    Environment = "sof-aws-teste"
  }
}