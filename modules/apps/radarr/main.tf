resource "null_resource" "default" {
  provisioner "file" {
    connection {
        type = "ssh"
        user = var.user
        private_key = file(var.private_key_path)
        host = var.host
    }

    source      = "../../modules/apps/radarr/scripts/radarr.sh"
    destination = "/tmp/radarr.sh"
  }  

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = var.user
        private_key = file(var.private_key_path)
        host = var.host
    }
  
    inline = [
        "sudo bash /tmp/radarr.sh"
    ]
  }
}
