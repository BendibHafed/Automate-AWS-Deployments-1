resource "aws_key_pair" "mykey" {
  key_name   = "deployer-key"
  public_key = "create a local id_rsa.pub and insert it here"
}

module "private_ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "private-single-instance"

  instance_type          = "t2.micro"
  ami                    = "ami-0c0493bbac867d427"
  key_name               = aws_key_pair.mykey.key_name
  monitoring             = false
  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "public_ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "public-single-instance"

  instance_type          = "t2.micro"
  ami                    = "ami-0c0493bbac867d427"
  key_name               = aws_key_pair.mykey.key_name
  monitoring             = false
  vpc_security_group_ids = [module.public_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
