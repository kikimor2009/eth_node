resource "null_resource" "run_ansible" {

  depends_on = [
    local_file.ansible_inventory,
    aws_volume_attachment.ebs_attach
  ]

  provisioner "local-exec" {
    command     = "until nc -zv ${aws_instance.eth_node.public_ip} 22; do echo 'Waiting for SSH to be available...'; sleep 5; done"
    working_dir = path.module
  }

  provisioner "local-exec" {
    command     = "ansible-galaxy collection install -r ./ansible/requirements.yaml && ansible-playbook ./ansible/main.yml"
    working_dir = path.module
  }
}