# add port specific access to the security groups

resource "aws_security_group" "eth-sg-ec2" {
  name   = "eth-sg-ec2"
  vpc_id = var.vpc_id
  tags = merge(
    {
      Name = "eth_ec2_sg"
    },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "eth-ssh" {
  security_group_id = aws_security_group.eth-sg-ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  tags = merge(
    {
      Name = "eth_ec2_ssh_ingress"
    },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "eth-icmp" {
  security_group_id = aws_security_group.eth-sg-ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  to_port     = -1
  ip_protocol = "icmp"

  tags = merge(
    {
      Name = "eth_ec2_icmp_ingress"
    },
    var.tags
  )
}

resource "aws_vpc_security_group_egress_rule" "eth-egress" {
  security_group_id = aws_security_group.eth-sg-ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = merge(
    {
      Name = "eth_ec2_all_outbound"
    },
    var.tags
  )
}