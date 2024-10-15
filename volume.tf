resource "aws_ebs_volume" "ebs" {
  size              = var.ebs_params.size
  type              = var.ebs_params.type
  iops              = var.ebs_params.iops
  throughput        = var.ebs_params.throughput
  availability_zone = aws_instance.eth_node.availability_zone
  tags = merge(
    {
      Name = "eth_ec2_ebs"
    },
    var.tags
  )
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.eth_node.id
}
