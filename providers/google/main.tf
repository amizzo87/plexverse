provider "google" {
  credentials		= file(var.auth_file_path)
  project     	= var.project_id
  region     		= var.zone
  version       = "~> 3.16"
}

resource "random_pet" "default" {
    length          = 3
    separator       = "-"
}

resource "google_storage_hmac_key" "default" {
    service_account_email = var.service_account_email
}


resource "google_storage_bucket" "default" {
  name     			= "plexverse-${random_pet.default.id}"
  location 			= var.zone
  storage_class	= "NEARLINE"
  force_destroy	= true
}

resource "google_compute_instance" "default" {
  name			 	= "plexverse"
  machine_type = var.machine_type
  zone				= "${var.zone}-a"

  boot_disk {
    initialize_params {
        image		= "ubuntu-os-cloud/ubuntu-1804-lts"
        size 		= "256"
        type 		= "pd-ssd"
    }
  }

  network_interface {
    network 		= "default"
    access_config {
        // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys 		= "ubuntu:${file(var.public_key_path)}"
  }
  
  service_account {
    scopes			= ["userinfo-email", "compute-rw", "storage-rw"]
  }
}

resource "google_compute_firewall" "default" {
  name              = "plexverse-firewall"
  network           = "default"

  allow {
    protocol        = "tcp"
    ports           = ["22", "80", "443", "32400", "8989", "8080", "7878"]
  }

  source_ranges     = ["0.0.0.0/0"]
}

module "bootstrap" {
    source          = "../../modules/bootstrap"
    private_key_path= var.private_key_path
    host            = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    user            = "ubuntu"
}

module "goofys" {
    source          = "../../modules/services/goofys"
    private_key_path= var.private_key_path
    host            = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    auth_key        = google_storage_hmac_key.default.access_id
    auth_secret     = google_storage_hmac_key.default.secret
    endpoint        = "https://storage.googleapis.com"
    bucket          = "plexverse-${random_pet.default.id}"
    user            = "ubuntu"
}

module "nginx" {
    source          = "../../modules/services/nginx"
    private_key_path= var.private_key_path
    host            = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    user            = "ubuntu"
}

module "plex" {
    source          = "../../modules/apps/plex"
    private_key_path= var.private_key_path
    host            = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    user            = "ubuntu"
}

module "sabnzbd" {
    source          = "../../modules/apps/sabnzbd"
    private_key_path= var.private_key_path
    host            = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    user            = "ubuntu"
}

module "sonarr" {
    source          = "../../modules/apps/sonarr"
    private_key_path= var.private_key_path
    host            = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    user            = "ubuntu"
}

module "radarr" {
    source          = "../../modules/apps/radarr"
    private_key_path= var.private_key_path
    host            = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
    user            = "ubuntu"
}