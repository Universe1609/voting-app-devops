provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      "project" = "todo-list"
    }
  }
}

module "vpc" {
  source = "./modules/VPC"

}

module "instances" {
  source                 = "./modules/EC2"
  environment            = "dev"
  public_subnet_id       = module.vpc.public_subnet_id
  private_subnet_id      = module.vpc.private_subnet_id
  jenkins_security_group = module.vpc.jenkins_security_group
  availability_zone      = "us-east-2a"
  instance_profile       = module.iam.instance_profile
}

module "iam" {
  source = "./modules/IAM"
}

//module "backend" {
//  source = "./modules/backend"
//}
