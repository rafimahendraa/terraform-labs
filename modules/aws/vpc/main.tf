locals {
  azs = {
    for index, az in var.availability_zones :
    az => {
      index               = index
      public_subnet_cidr  = var.public_subnet_cidrs[index]
      private_subnet_cidr = var.private_subnet_cidrs[index]
    }
  }

  nat_gateway_azs = var.nat_gateway_mode == "single" ? {
    single = {
      az = var.availability_zones[0]
    }
    } : {
    for az in var.availability_zones :
    az => {
      az = az
    }
  }
}

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block = var.vpc_cidr

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-vpc"
    }
  )
}

resource "aws_internet_gateway" "this" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  for_each = var.create_vpc ? local.azs : {}

  vpc_id = aws_vpc.this[0].id

  cidr_block        = each.value.public_subnet_cidr
  availability_zone = each.key

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-public-${each.key}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  for_each = var.create_vpc ? local.azs : {}

  vpc_id = aws_vpc.this[0].id

  cidr_block        = each.value.private_subnet_cidr
  availability_zone = each.key

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-private-${each.key}"
      Tier = "private"
    }
  )
}

resource "aws_route_table" "public" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  for_each = var.create_vpc ? local.azs : {}

  subnet_id = aws_subnet.public[each.key].id

  route_table_id = aws_route_table.public[0].id
}

resource "aws_eip" "nat" {
  for_each = var.create_vpc ? local.nat_gateway_azs : {}

  domain = "vpc"

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-nat-eip-${each.key}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = var.create_vpc ? local.nat_gateway_azs : {}

  allocation_id = aws_eip.nat[each.key].id

  subnet_id = var.nat_gateway_mode == "single" ? (
    aws_subnet.public[var.availability_zones[0]].id
    ) : (
    aws_subnet.public[each.key].id
  )

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-nat-${each.key}"
    }
  )
}

resource "aws_route_table" "private" {
  for_each = var.create_vpc ? local.nat_gateway_azs : {}

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = merge(
    var.common_tags ,
    {
      Name = "${var.name}-private-rt-${each.key}"
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each = var.create_vpc ? local.azs : {}

  subnet_id = aws_subnet.private[each.key].id

  route_table_id = var.nat_gateway_mode == "single" ? (
    aws_route_table.private["single"].id
    ) : (
    aws_route_table.private[each.key].id
  )
}
