resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = format("%s/%s/%s", abspath(path.module), "keys", "ansible-ssh-key.pem")
  file_permission = "0600"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    ip_addrs       = [aws_instance.eth_node.public_ip]
    ssh_keyfile    = local_sensitive_file.private_key.filename
    ebs_volume_id  = replace(aws_ebs_volume.ebs.id, "-", "")
    ebs_mount_path = var.ebs_mount_path
  })
  filename = format("%s/%s", abspath(path.module), "/ansible/inventory.ini")
}