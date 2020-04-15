resource "null_resource" "default" {

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = var.user
        private_key = file(var.private_key_path)
        host = var.host
    }

    inline = [
      "sudo apt-get update && sudo apt-get -y upgrade",
      "sleep 15",
      "sudo apt-get install -y software-properties-common aptdaemon"
    ]
  }
}