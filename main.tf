provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_packer" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["my-custom-ami-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_packer.id
  instance_type = "t2.micro"

    user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Hello World</h1>" > /var/www/html/index.html
              EOF    
  
  tags = {
    Name = "Terraform-Deployed-Instance"
  }
}

