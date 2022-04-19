variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "source_ami" {
  type = string
}


packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-base-template"
  instance_type = "t2.micro"
  region        = var.region

  source_ami     = var.source_ami
  ssh_username = "ubuntu"
  access_key   = var.access_key
  secret_key = var.secret_key
}


build {
  name    = "aws-ubuntu-base"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
      scripts = ["scripts/provision.sh","scripts/docker.sh"]
  }
}