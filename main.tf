provider "aws" {
    region = var.region
  
}

module "vpc" {
    source = "./modules/vpc"
    subnets = {
      "public 1" = {
        cidr = "10.0.1.0/24"
        az = "us-east-1a"
        public = true
      }

      "private 1" = {
        cidr = "10.0.2.0/24"
        az = "us-east-1a"
        public = false
      }
    }
    vpc-cidr = "10.0.0.0/16"
    route-cidr = "0.0.0.0/0"
    

    
  
}

module "instance" {
    source = "./modules/instance"
    instance = "t2.micro"
    ami = "ami-0866a3c8686eaeeba"
    subnet = module.vpc.module-subnet.id
  
}
