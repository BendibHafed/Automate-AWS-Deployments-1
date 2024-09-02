resource "aws_key_pair" "mykey" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtjWmlTK/7z48xSWJLDmsNQ1BEhGlyi5jC2PzRe7+tg9wonR89FTgkhkhK+THNBNKKWRyf1DoJ8oi0Oc6DOwND6+T3Mn9wXIR62yPzH1zZfwZXy3sHd6JHXV9Uc+RCOm453T4koRGNK5AdLIBayvwn5E0Hd6TNZktau5TCgku/jU7vySgy1s4RIs+0Ud4jQUCYwUFWjsPGOltM738iOIU0LlG/cOYjoESksBQeJR4coiDIQZFFHXdMcjmG4Vl1IxZ2dMFnRJUN7tu42aqKIF6BGJ5HpqgYjEKB1Xf/1rGJsnZvRNl+KSqVEwt/20s9jBc8VDsPE76Bg5VKPZOH1+sEk+ckslR84LXTIRBNIF8vgcdd2JY0IVc39EBUITgw0PPyS9W1aDCyBgu2veITMskdrtCa42yM0FzbkFN6Kv6tGx+MkvVXOUS/EYgqkHoTOqJQrVY3vX/Nwh1vlYNN4q0TJX9hJVY8jg3ao8Of3w1RCHr7hdmIjwJEGiJsaYJx/0M= hafed@hafed-Inspiron-3542"
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