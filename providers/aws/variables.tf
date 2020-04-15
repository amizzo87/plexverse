variable "auth_file_path" {
	description = "Relative path to the AWS credentials CSV file"
	default = "../../auth/aws_creds.csv"
}

variable "region" {
	description = "AWS region"
	default = "us-east-1"
}

variable "machine_type" {
	description = "Desired machine type (i.e. t3a.small)"
	default = "t3a.small"
}

variable "public_key_path" {
	description = "Public key path"
	default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
	description = "Private key path"
	default = "~/.ssh/id_rsa"
}
