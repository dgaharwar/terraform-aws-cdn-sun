data "aws_availability_zones" "available" {}

resource "aws_vpc" "s3_distribution" {
  cidr_block = "101.0.0.0/16"
}

resource "aws_subnet" "az_01" {
  vpc_id            = aws_vpc.s3_distribution.id
  cidr_block        = "101.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "az_02" {
  vpc_id            = aws_vpc.s3_distribution.id
  cidr_block        = "101.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "az_03" {
  vpc_id            = aws_vpc.s3_distribution.id
  cidr_block        = "101.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]
}

resource "aws_security_group" "s3_distribution" {
  name   = "PTAWSG-TEST-EXAMPLE-SG"
  vpc_id = aws_vpc.s3_distribution.id

  lifecycle {
    create_before_destroy = true
  }
}
