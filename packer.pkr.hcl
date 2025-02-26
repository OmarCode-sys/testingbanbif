packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "example" {
  ami_name      = "my-custom-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS
  ssh_username  = "ubuntu"

  tags = {
    Name        = "PackerBuiltAMI"
    CreatedBy   = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }
}
