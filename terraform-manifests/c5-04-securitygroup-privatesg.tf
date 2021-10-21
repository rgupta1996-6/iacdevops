# AWS EC2 Security Group Terraform Module
# Security Group for Private EC2 Instances
module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "3.18.0"
  version = "4.0.0"
  
  #name = "private-sg"
  name = "${local.name}-private-sg"  
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all world open"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 9935
      to_port     = 9935
      protocol    = 6
      description = "Allow Port 9935 from internet"
      cidr_blocks = "10.0.0.0/16"
    },
      {
      from_port   = 9945
      to_port     = 9945
      protocol    = 6
      description = "Allow Port 9945 from internet"
      cidr_blocks = "10.0.0.0/16"
    },
     {
      from_port   = 30337
      to_port     = 30337
      protocol    = 6
      description = "Allow Port 9945 from internet"
      cidr_blocks = "10.0.0.0/16"
    },
     {
      from_port   = 30335
      to_port     = 30335
      protocol    = 6
      description = "Allow Port 9945 from internet"
      cidr_blocks = "10.0.0.0/16"
    },
  ]
  tags = local.common_tags
}

