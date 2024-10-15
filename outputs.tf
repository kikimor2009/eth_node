output "ec2_instance_data" {
  value = [for vm in aws_instance.eth_node[*] : {
    ip_address = vm.public_ip
    public_dns = vm.public_dns
  }]
  description = "The public IP and DNS of the nodes"
}