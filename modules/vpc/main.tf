## VPC ##
resource "aws_vpc" "test-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = "true"
}

## SUBNETS ##
resource "aws_subnet" "test-subnet" {
  for_each = toset( var.availability_zones )
  
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = each.key
}

## ROUTE TABLE ##
resource "aws_route_table" "test-route-table" {
  vpc_id = aws_vpc.test-vpc.id
}

## GATEWAY ##
resource "aws_internet_gateway" "test-gw" {
  vpc_id = aws_vpc.test-vpc.id
}

## ROUTE ##
resource "aws_route" "test-route" {
  route_table_id         = aws_route_table.test-route-table.id
  gateway_id             = aws_nat_gateway.test-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

## ROUTE TABLE ASSOCIATION ##
resource "aws_main_route_table_association" "main-route-table" {
  vpc_id         = aws_vpc.test-vpc.id
  route_table_id = aws_route_table.test-route-table.id
}

## OUTPUT ##
output "vpc_id" {
  value = aws_vpc.test-vpc.id
}

output "subnets" {
  value = aws_subnet.test-subnet.id[*]
}