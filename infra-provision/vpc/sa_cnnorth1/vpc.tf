locals {
  availability_zone_count = length(split(",", var.availability_zones))
}

# Create a new VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "my-vpc"
    }
}

resource "aws_internet_gateway" "default_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_eip" "nat" {
  count = var.subnet_no_private
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    GBL_CLASS_0 = "SVC"
    GBL_CLASS_1 = "EIP"
 }
}

resource "aws_nat_gateway" "nat" {
  count = var.subnet_no_private

  allocation_id = aws_eip.nat[count.index].id

  //subnet_id = "${aws_subnet.private.0.id}"
  subnet_id = aws_subnet.public_subnet[count.index % local.availability_zone_count].id

  /*lifecycle {
      create_before_destroy = true
    }*/
  tags = {
    Name = "${var.vpc_name}-private${count.index}-natgw"
    GBL_CLASS_0 = "SERVICE"
    GBL_CLASS_1 = "nat_gateway"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    count  = local.availability_zone_count

    cidr_block              = "10.${var.cidr_numeral}.${var.cidr_numeral_public[count.index]}.0/20"
    availability_zone       = element(split(",", var.availability_zones), count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.vpc_name}-public-subnet"
    }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.vpc_name}-my-igw"
    }
}

# Create a route table for public subnet
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "${var.vpc_name}-public-route-table"
    }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_route_association" {
    count          = local.availability_zone_count
    subnet_id      = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
    count  = var.subnet_no_private
    vpc_id = aws_vpc.my_vpc.id

    # Please change cidr_block after migration. will use only 20 bit subnet mask.
    cidr_block = "10.${var.cidr_numeral}.${var.cidr_numeral_private[count.index]}.0/${count.index < 5 ? 20 : 24}"
    availability_zone = element(
        split(",", var.availability_zones),
        count.index % local.availability_zone_count,
    )

    tags = {
        Name = "${var.vpc_name}-private-subnet"
    }
}

resource "aws_route_table" "private_route_table" {
  count  = var.subnet_no_private
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name    = "${var.vpc_name}-private${count.index}-route-table"
    Network = "Private"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_no_private
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

# DB PRIVATE SUBNETS
#
# Route Tables in a private subnet will not have Route resources created
# statically for them as the NAT instances are responsible for dynamically
# managing them on a per-AZ level using the Network=Private tag.

resource "aws_subnet" "private_db" {
  count  = local.availability_zone_count
  vpc_id = aws_vpc.my_vpc.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private_db[count.index]}.0/20"
  availability_zone = element(split(",", var.availability_zones), count.index)

  tags = {
    Name               = "${var.vpc_name}-db-private${count.index}"
    Network            = "Private"
  }
}

resource "aws_route_table" "private_db" {
  count  = local.availability_zone_count
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  
  tags = {
    Name    = "${var.vpc_name}-privatedb${count.index}-route-table"
    Network = "Private"
  }
}

resource "aws_route_table_association" "private_db" {
  count          = local.availability_zone_count
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db[count.index].id
}


  