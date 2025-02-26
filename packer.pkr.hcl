packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "custom-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c078c0b25ad46e40"  # Ubuntu 22.04 LTS
  ssh_username  = "ubuntu"

  tags = {
    Name        = "PackerBuiltAMI"
    CreatedBy   = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y httpd",
      "sudo systemctl start httpd"
      "sudo systemctl enable httpd"
    ]
  }
}
