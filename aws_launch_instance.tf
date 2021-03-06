provider "aws" {
  region = "ap-south-1"
  profile = "default"
}
// key-pair


module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "task-one"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 harshguptashnd@gmail.com"
}


resource "aws_security_group" "my_security_group" {
  name        = "wizard-1"
  description = "Allow TLS inbound traffic"
  
  
  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "6"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port   = 22
      to_port    = 22
      protocol    = "6"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wizard-1"
  }
}

resource "aws_instance" "task1" {
  ami           = "ami-0fd7b184f79e8e5af"
  
  instance_type = "t2.micro"
  key_name      =  "task-one"
  security_groups = ["wizard-1"]
	
  tags = {
    Name = "My_Terraform_OS"
  }
  user_data = <<-EOF
	         #!bin/bash
		 yum install httpd -y
		 yum install git -y
		 git clone https://github.com/Harsh-Gupta9897/Task1.git
		 cd Task1
		 cp index.html /var/www/html/index.html
		 systemctl start httpd
  EOF

}


resource "aws_ebs_volume" "mypendrive" {
  availability_zone = aws_instance.task1.availability_zone
  size              = 1

  tags = {
    Name = "mypendrive"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.mypendrive.id}"
  instance_id = "${aws_instance.task1.id}"
}

output  "my_sec_public_ip" {
	value = aws_instance.task1.public_ip
}

