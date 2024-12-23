resource "aws_instance" "module-instance" {
    ami = var.ami
    instance_type = var.instance
    key_name = "Cloudops"
    subnet_id = var.subnet
  
}