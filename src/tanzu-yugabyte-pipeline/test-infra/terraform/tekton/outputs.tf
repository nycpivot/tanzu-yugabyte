output "ip" {
 value = "${aws_instance.tekton.public_ip}"
}
output "ec2instance" {
 value = "${aws_instance.tekton.id}"
}