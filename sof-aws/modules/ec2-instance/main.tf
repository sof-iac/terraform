module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  count = length(var.ec2-instance)

  name = var.ec2-instance[count.index].name

  ami                    = var.ec2-instance[count.index].ami
  instance_type          = var.ec2-instance[count.index].type
  key_name               = var.ec2-instance[count.index].access-key-name
  ebs_optimized          = true
  vpc_security_group_ids = var.ec2-instance[count.index].vpc-security-group-ids
  subnet_id              = var.ec2-instance[count.index].subnet-id

  tags = {
    Environment = var.ec2-instance[count.index].env
    Terraform   = "true"
  }
}