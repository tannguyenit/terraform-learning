# Fetch AZs in the current region
data "aws_availability_zones" "available" {

}

data "aws_vpc" "main" {
  count = var.is_exists_vpc == true ? 1 : 0
  id    = var.vpc_id
}

data "aws_internet_gateway" "gateway" {
  count = var.is_exists_vpc == true ? 1 : 0
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_vpc" "main" {
  count                = var.is_exists_vpc == true ? 0 : 1
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(var.is_exists_vpc == true ? data.aws_vpc.main[0].cidr_block : aws_vpc.main[0].cidr_block, 8, count.index + var.default_index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = var.is_exists_vpc ? data.aws_vpc.main[0].id : aws_vpc.main[0].id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.subnet_public_name}-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "app_private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(var.is_exists_vpc == true ? data.aws_vpc.main[0].cidr_block : aws_vpc.main[0].cidr_block, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = var.is_exists_vpc ? data.aws_vpc.main[0].id : aws_vpc.main[0].id
  tags = {
    Name = "${var.subnet_private_name}-app-${count.index}"
  }
}


# Create private subnets
resource "aws_subnet" "db_private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(var.is_exists_vpc == true ? data.aws_vpc.main[0].cidr_block : aws_vpc.main[0].cidr_block, 8, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = var.is_exists_vpc ? data.aws_vpc.main[0].id : aws_vpc.main[0].id
  tags = {
    Name = "${var.subnet_private_name}-db-${count.index}"
  }
}


# Create internet gateway for the public subnet
resource "aws_internet_gateway" "gateway" {
  count  = var.is_exists_vpc == true ? 0 : 1
  vpc_id = var.is_exists_vpc == true ? data.aws_vpc.main[0].id : aws_vpc.main[0].id
}

# Create the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = var.is_exists_vpc == true ? data.aws_vpc.main[0].main_route_table_id : aws_vpc.main[0].main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.is_exists_vpc == true ? data.aws_internet_gateway.gateway[0].id : aws_internet_gateway.gateway[0].id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gateway" {
  count      = var.az_count
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_nat_gateway" "gateway" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
}

# Create new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = var.is_exists_vpc == true ? data.aws_vpc.main[0].id : aws_vpc.main[0].id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }

  tags = {
    Name = "rtb-private-${count.index}"
  }
}

# Explicitly associate the newly created to the private subnets
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.app_private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Create new route table for the public subnet
resource "aws_route_table" "public" {
  count  = var.az_count
  vpc_id = var.is_exists_vpc == true ? data.aws_vpc.main[0].id : aws_vpc.main[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.is_exists_vpc == true ? data.aws_internet_gateway.gateway[0].id : aws_internet_gateway.gateway[0].id
  }
  tags = {
    Name = "rtb-public-${count.index}"
  }
}

# Explicitly associate the newly created to the public subnets
resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}