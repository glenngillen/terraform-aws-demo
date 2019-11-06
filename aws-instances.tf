variable "instance_type" {
  type    = "string"
  default = "t3.micro"
}

variable "vpc_id" {
  type    = "string"
  default = "vpc-ee374694"
}

variable "default-security-group" {
  type    = "string"
  default = "sg-6b30d337"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_subnet" "us-east-1a" {
  vpc_id      = var.vpc_id
  cidr_block  = "172.31.16.0/20"
}
resource "aws_subnet" "us-east-1b" {
  vpc_id      = var.vpc_id
  cidr_block  = "172.31.32.0/20"
}
resource "aws_subnet" "us-east-1c" {
  vpc_id      = var.vpc_id
  cidr_block  = "172.31.0.0/20"
}
resource "aws_subnet" "us-east-1d" {
  vpc_id      = var.vpc_id
  cidr_block  = "172.31.80.0/20"
}
resource "aws_subnet" "us-east-1e" {
  vpc_id      = var.vpc_id
  cidr_block  = "172.31.64.0/20"
}
resource "aws_subnet" "us-east-1f" {
  vpc_id      = var.vpc_id
  cidr_block  = "172.31.48.0/20"
}

resource "aws_launch_template" "web" {
  name = "ggillen-web-template"
  disable_api_termination = true
  image_id = "${data.aws_ami.ubuntu.id}"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type
  vpc_security_group_ids = [var.default-security-group]
}

resource "aws_placement_group" "web" {
  name     = "ggillen-web"
  strategy = "spread"
}

resource "aws_s3_account_public_access_block" "global_block" {
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket" "bucket-1" {
  bucket = "cost-estimation-bucket-1"
  acl    = "private"
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}