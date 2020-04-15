resource "null_resource" "default" {
  provisioner "file" {
    connection {
        type = "ssh"
        user = var.user
        private_key = file(var.private_key_path)
        host = var.host
    }

    source      = "../../modules/apps/sabnzbd/scripts/sabnzbd.sh"
    destination = "/tmp/sabnzbd.sh"
  }  

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = var.user
        private_key = file(var.private_key_path)
        host = var.host
    }
  
    inline = [
        "sudo bash /tmp/sabnzbd.sh"
    ]
  }
}
