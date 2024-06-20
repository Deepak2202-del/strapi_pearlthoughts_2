provider "aws" {
  region = var.region
}

resource "aws_instance" "strapi" {
  ami           = "ami-04b70fa74e45c3917"  # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = var.key_name  # Reference the key_name variable

  tags = {
    Name = "strapi-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      "sudo apt install -y nodejs",
      "git clone https://github.com/Deepak2202-del/strapi_pearlthoughts_2.git",
      "cd strapi_pearlthoughts_2",
      "npm install",
      "npm run build",
      "npm run start",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/PearlThoughts_N.Virginia_key.pem")  # Reference the private_key variable
    host        = self.public_ip
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
  EOF
}

resource "aws_security_group" "allow_ssh_http" {
  vpc_id = "vpc-0d1ad4d1d4296cc2b"  # Replace with your VPC ID

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

  tags = {
    Name = "allow_ssh_http"
  }
}


