resource "aws_vpc" "secure_production" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "secure-production"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.secure_production.id
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1a"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-east-1b"
  vpc_id                  = aws_vpc.secure_production.id
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1b"
  }
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.secure_production.id

  tags = {
    Name = "custom-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.secure_production.id

  tags = {
    Name = "public_subnet_rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "rds_SG" {
  name        = "allow_traffic"
  description = "Allow inbound traffic and outbound"
  vpc_id      = aws_vpc.secure_production.id

  tags = {
    Name = "rds-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  security_group_id = aws_security_group.rds_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.rds_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}