resource "aws_vpc" "module-vpc" {
    cidr_block = var.vpc-cidr
    enable_dns_hostnames = true
    enable_dns_support = true
  
}

resource "aws_internet_gateway" "module-igw" {
    vpc_id = aws_vpc.module-vpc.id
  
}

resource "aws_subnet" "module-subnet" {
    for_each = var.subnets
    vpc_id = aws_vpc.module-vpc.id
    availability_zone = each.value.az
    cidr_block = each.value.cidr
    map_public_ip_on_launch = each.value.public
  
}

resource "aws_route_table" "module-public-rtb" {
    vpc_id = aws_vpc.module-vpc.id
    route  {
        gateway_id = aws_internet_gateway.module-igw.id
        cidr_block = var.route-cidr
    }
  
}

resource "aws_route_table_association" "module-rtba" {
    for_each = {for key, subnet in var.subnets : key => subnet if subnet.public == true }
    subnet_id = aws_subnet.module-subnet[each.key].id
    route_table_id = aws_route_table.module-public-rtb.id

  
}

resource "aws_eip" "module-eip" {
    domain = "vpc"
  
}

resource "aws_nat_gateway" "module-nat" {

    allocation_id = aws_eip.module-eip.id
    subnet_id = aws_subnet.module-subnet["public 1"].id
  
}

resource "aws_route_table" "module-private-rtb" {
    vpc_id = aws_vpc.module-vpc.id
    route {
        nat_gateway_id = aws_nat_gateway.module-nat.id
        cidr_block = var.route-cidr
    }
  
}

resource "aws_route_table_association" "module-pri-rtba" {
    for_each = {for key, subnet in var.subnets : key => subnet if subnet.public == false }
    subnet_id = aws_subnet.module-subnet[each.key].id
    route_table_id = aws_route_table.module-private-rtb
    
  
}
