resource "null_resource" "default" {

  provisioner "file" {
    connection {
        type = "ssh"
        user = var.user
        private_key = file(var.private_key_path)
        host = var.host
    }

    source      = "../../modules/apps/plex/scripts/plex.sh"
    destination = "/tmp/plex.sh"
  }

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = var.user
        private_key = file(var.private_key_path)
        host = var.host
    }
  
    inline = [
      "sudo bash /tmp/plex.sh"
    ]
  }
}