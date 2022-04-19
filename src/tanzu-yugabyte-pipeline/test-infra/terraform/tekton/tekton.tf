data "aws_subnet" "publicsubnet" {
        id = "subnet-07586642994adb674"
        
}

resource "aws_key_pair" "bootstrap" {
  key_name   = "bootstrap-key"
  public_key = var.bootstrap_key

}
resource "aws_network_interface" "tekton" {
  subnet_id   = data.aws_subnet.publicsubnet.id
  private_ips = ["192.0.2.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "tekton" {
 ami             = "${var.ami_tekton}"
 instance_type   = "${var.instance_type}"
 vpc_security_group_ids =["${aws_security_group.sg.id}"]
 key_name = "${aws_key_pair.bootstrap.id}"
 tags = "${local.common_tags}"
  root_block_device {
    volume_size = "100"
  }
  connection {
        host = self.public_ip
        user = "ubuntu"
        private_key = file("bootstrap_rsa")
      }
  provisioner "remote-exec" {
    inline = [
      "sudo cp /root/launch.sh .",
    ]
  }
  provisioner "remote-exec" {
      scripts = ["scripts/utils.sh", "scripts/awscli.sh"]
  }

}