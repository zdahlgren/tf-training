##
# Your AMI ID is:
#
#     ami-eea9f38e
#
# Your subnet ID is:
#
#     subnet-b30f9ceb
#
# Your security group ID is:
#
#     sg-834d35e4
#
# Your Identity is:
#
#     autodesk-moth
#

terraform {
  backend "atlas" {
    name = "dahlgrz/training"
  }
}

module "example" {
  source  = "./example-module"
  command = "echo Goodbye, world!"
}

variable "max_instances" {
  default = "3"
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-west-1"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "${var.max_instances}"
  ami                    = "ami-eea9f38e"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-b30f9ceb"
  vpc_security_group_ids = ["sg-834d35e4"]

  tags {
    "Identity"     = "autodesk-moth"
    "Initial_Name" = "zach-the-moth"
    "Name"         = "web ${count.index+1} / ${var.max_instances}"
    "Purpose"      = "learning" lol
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "name" {
  value = ["${aws_instance.web.*.tags.Name}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

output "module_command" {
  value = ["${module.example.command}"]
}

output "blah_blah_blah" {
  value = ["${module.example.command}"]
}
