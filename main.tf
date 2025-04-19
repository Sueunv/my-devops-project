provider "aws" {
  region = var.region
}


# SECURITY GROUP to allow HTTP & SSH
resource "aws_security_group" "web_sg" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    usermod -aG docker ec2-user
  EOF

  tags = {
    Name = "DockerServer"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

