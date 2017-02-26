provider "google" {
  credentials		= "${file("${var.auth_file_path}")}"
  project     		= "${var.project_id}"
  region     		= "${var.project_zone}"
}

resource "google_storage_bucket" "default" {
  name     			= "${var.project_id}-bucket"
  location 			= "${var.storage_zone}"
  storage_class 	= "NEARLINE"
  force_destroy		= "true"
}

resource "google_compute_instance" "default" {
  name				= "plex-gcloud"
  machine_type		= "${var.machine_type}"
  zone				= "${var.machine_zone}"

  disk {
    image			= "ubuntu-os-cloud/ubuntu-1604-lts"
    size 			= "128"
    type 			= "pd-ssd"
  }

  network_interface {
    network 		= "default"
    access_config {
    
    }
  }

  metadata {
    ssh-keys 		= "root:${file("${var.public_key_path}")}"
  }
  
  service_account {
    scopes			= ["userinfo-email", "compute-rw", "storage-rw"]
  }
  
  provisioner "file" {
  	connection {
      type			= "ssh"
      user			= "root"
      private_key 	= "${file("${var.private_key_path}")}"
      agent       	= false
    }
    
  	source 			= "scripts"
  	destination 	= "/home/root/"	
  }
  
provisioner "remote-exec" {
  	connection {
      type    		= "ssh"
      user        	= "root"
      private_key 	= "${file("${var.private_key_path}")}"
      agent       	= false
    }
    
  	inline 			= [
  						"sudo chmod +x /home/root/*.sh",
  						"sudo bash /home/root/000-init.sh",
  						"sudo mkdir /root/.s3ql",
  						"sudo printf '[gs]\nstorage-url: gs://${var.project_id}-bucket/\nbackend-login: oauth2\nbackend-password: ' > /root/.s3ql/authinfo2",
  						"screen -d -m -L s3ql_oauth_client",
  						"sudo bash /home/root/001-s3ql.sh",
  						"sudo chmod 0600 /root/.s3ql/authinfo2",
  						"sudo mkfs.s3ql --cachedir /var/cache/s3ql --authfile /root/.s3ql/authinfo2 --plain gs://${var.project_id}-bucket/",
  						"sudo printf '[Unit]\nDescription=mount s3ql filesystem\nWants=network-online.target\n[Service]\nExecStart=/usr/bin/mount.s3ql --fg --allow-other --authfile /root/.s3ql/authinfo2 --cachedir /var/cache/s3ql --cachesize 8000000 --compress none --max-cache-entries 65536 --metadata-upload-interval 3600 gs://${var.project_id}-bucket/ /cloud1\nExecStop=/usr/bin/umount.s3ql /cloud1\nTimeoutStopSec=60' > /lib/systemd/system/s3ql.service",
        				"sudo systemctl enable s3ql",
        				"sudo systemctl start s3ql",
        				"sudo bash /home/root/002-plex.sh",
        				"sudo bash /home/root/003-sabnzbd.sh",
        				"sudo bash /home/root/004-sonarr.sh",
        				"sudo bash /home/root/005-radarr.sh",
        				"sudo rm /home/root/*.sh"
  					  ]
  }
}

resource "google_compute_firewall" "default" {
  name    = "plex-gcloud-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["32400", "8989", "7878", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

  output "machine_ip" {
    value		 	= "${google_compute_instance.default.network_interface.0.access_config.0.assigned_nat_ip}"
}