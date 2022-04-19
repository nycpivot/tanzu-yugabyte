variable "ami_name_filter" {
   description = "Filter to use to find the AMI by name"
   default = "http-benchmarking-*"
}
 
variable "ami_owner" {
   description = "Filter for the AMI owner"
   default = "self"
}
variable "instance_type" {
   description = "Type of EC2 instance"
   default = "t2.medium"
}
 
variable "keypair" {
   description = "Key pair to access the EC2 instance"
   default = "default"
}
 
variable "allow_ssh_from_cidrs" {
   description = "List of CIDRs allowed to connect to SSH"
   default = ["0.0.0.0/0"]
}

variable "secret_key" {

}
variable "region" {

}
 
variable "tag_name" {
   description = "Value of the tags Name to apply to all resources"
   default = "tekton"
}

variable "bootstrap_key" {

}

variable "ami_tekton"{

}

variable "access_key" {

}
