############################################################################
#
# Set AWS provider and AWS key-pair
#
############################################################################

provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region = "${var.AWS_REGION}"
}

resource "aws_key_pair" "mykeypair" {
  key_name = "mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}

############################################################################
#
# Set security groups
#
############################################################################

resource "aws_security_group" "interview-sg" {
  vpc_id = "${aws_vpc.main.id}"
  name = "interview-sg"
  description = "Allow ingress SSH and Kibana port from all servers"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 22
      to_port = 22
      protocol = "6"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress {
      from_port = 5601
      to_port = 5601
      protocol = "6"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  tags {
    Name = "interview-sg"
  }
}

############################################################################
#
# Set up VPC, subnets, internet gateway, and route tables
#
############################################################################

# Main VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16" 
    instance_tenancy = "default" 
    enable_dns_support = "true" 
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "main"
    }
}

# Public subnet in us-west-2a
resource "aws_subnet" "main-public" {
    vpc_id = "${aws_vpc.main.id}"    
    cidr_block = "10.0.1.0/24"        
    map_public_ip_on_launch = "true" 
    availability_zone = "us-west-2a" 
    tags {
        Name = "main-public"
    }
}

# Internet gateway
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "main"
    }
}

# Route table
resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }
    tags {
        Name = "main-public"
    }
}

# Route to public subnet in us-west-2a
resource "aws_route_table_association" "main-public" {
    subnet_id = "${aws_subnet.main-public.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}
