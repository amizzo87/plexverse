variable "auth_file_path" {
	description = "Relative path to the Google Cloud Service Account .json auth file for your project"
	default = "../../auth/account.json"
}

variable "service_account_email" {
	description = "The email associated with the SERVICE ACCOUNT of the auth file you just created, i.e. plexverse@fiery-arctic-12345.iam.gserviceaccount.com"
	// default = "plexverse@fiery-arctic-12345.iam.gserviceaccount.com"
}

variable "public_key_path" {
	description = "Public key path"
	default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
	description = "Private key path"
	default = "~/.ssh/id_rsa"
}

variable "project_id" {
	description = "Google Project ID (NOT project name) - must have been created before starting this script"
	// default = "fiery-arctic-12345"
}

variable "zone" {
	// Choose a general zone from https://cloud.google.com/about/locations/
	description = "Google Project Zone (choose from https://cloud.google.com/about/locations/)"
	default = "us-central1"
}

variable "machine_type" {
	// Choose a machine type name from https://cloud.google.com/compute/docs/machine-types#predefined_machine_types
	// Recommended: n1-highcpu-4 for several concurrent transcoding and streaming jobs
	description = "Desired machine type (i.e. n1-highcpu-4)"
	default = "n1-highcpu-4"
}