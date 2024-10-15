data "aws_ami" "ubuntu-22-04-amd64-server" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws_key" {
  key_name   = "ansible-ssh-key"
  public_key = tls_private_key.key.public_key_openssh
  tags = merge(
    {
      Name = "eth_ec2_ssh_key"
    },
    var.tags
  )
}

resource "aws_instance" "eth_node" {
  ami                         = data.aws_ami.ubuntu-22-04-amd64-server.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.aws_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.eth-sg-ec2.id]
  subnet_id                   = var.subnet_id
  tags = merge(
    {
      Name = "eth_ec2_eth_node"
    },
    var.tags
  )

  lifecycle {
      prevent_destroy = true
  }

  provisioner "local-exec" {
    command = "aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id}"
  }
}