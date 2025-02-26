provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_packer" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["custom-ami-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_packer.id
  instance_type = "t2.micro"

    user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Hello World Omar</h1>" > /var/www/html/index.html
              EOF    
  
  tags = {
    Name = "Terraform-Deployed-Instance"
  }
}

resource "aws_security_group" "website" {
  name        = "website"
  description = "Permite SSH y HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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