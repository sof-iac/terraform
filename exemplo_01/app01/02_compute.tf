module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "tf-teste-instance"

  ami                    = "ami-05240a8eacac22db2"
  instance_type          = "t3.small"
  key_name               = "tf-teste"
  monitoring             = true
  vpc_security_group_ids = ["${module.vpc.default_security_group_id}"]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "sof-aws-teste"
  }
}