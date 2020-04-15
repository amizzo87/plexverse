# Plexverse

Get Plex + Sonarr + Radarr + SABnzbd automatically installed in either AWS or Google Cloud, with near-infinite (and affordable) storage.

Automated deployment using [Terraform](https://www.terraform.io)

## Prerequisites
- Install Terraform from [terraform.io](https://www.terraform.io/downloads.html) 
- A Usenet account - [NewsgroupNinja](https://www.newsgroup.ninja/) recommended
- A Usenet indexer - [NZBGeek](https://nzbgeek.info) recommended

### AWS
- Create an IAM key/secret pair, save as `plexverse/auth/aws_creds.csv`

### Google Cloud (BETA - SEE KNOWN ISSUES)
- Create a Google Cloud Platform Account
- Create a new project, taking note of the project ID
- Get authentication JSON file:
    - Log into [Google Developers Console](https://console.developers.google.com/), select your project
    - Select API Manager View, click "Credentials" on left, then "Create Credentials," then finally "Service Account Key"
    - Select "Compute Engine default service account" in the "Service Account" dropdown, select "JSON" as key type

## Usage
1. `git clone` this repo.
2. Enter `plexverse/providers/[PROVIDER]` depending on which cloud platform you'd like to deploy to.
3. Change/populate variables in `variables.tf` as desired. 
4. Run `terraform init` then `terraform plan` to confirm everything is set properly.
5. Run `terraform apply` to create the Plexverse stack, taking note of the `<machine_ip>` displayed at the end of creation.

## Post-Installation 
Please perform these configurations in the order listed.

### Plex
1. You need to create an SSH tunnel to access Plex for the initial set up. To do this, run `ssh -i ~/.ssh/id_rsa root@<machine_ip> -L 8888:localhost:32400`. You'll then need to use it by going to `localhost:8888/web` and manually enable remote management for Plex (**v. important!**).
2. Add a Movies library in Plex and point it to `/plexmedia/Movies`
3. Add a TV Shows libarary in Plex and point it to `/plexmedia/TV Shows`

### SABnzbd
1. Go to `http://<machine_ip>/sabnzbd` and complete the intial set up (including adding your Usenet server credentials), taking note to create a username and password for security purposes.
2. Go to SABnzbd config and take note of the "API Key." You'll need to enter this in both Sonarr and Radarr in the next steps.

### Sonarr
1. Go to `http://<machine_ip>/sonarr` then to "Settings."
2. On the "Media Management" tab, change "Rename Episodes" to "Yes."
3. On the "Indexers" tab, add your preferred Usenet indexer settings and API key.
4. On the "Download Client" tab, add "SABnzbd" with the username/password and API key you received from the "SABnzbd" step of configuration above.
5. On the "General" tab, change "Authentication" to "Basic (Browser popup)" and enter a username and password. Click "Save."
6. Go to the "System" icon and restart Sonarr using the restart icon in the upper right corner of the frame.
7. Add your first TV series to Sonar. Under "Path," click "Add a different path" and browse to select `/plexmedia/TV Shows`. This will now be the default for future shows you add.
8. Click the plus sign to add the show, then visit the page for the show you just added in Sonarr, and click the magnifying glass, either for the whole series or a specific show/season, to trigger searching, downloading, and processing. 

### Radarr
1. Go to `http://<machine_ip>/radarr` then to "Settings." 
2. Everything else is the same as with Sonarr (above), except make sure to add the path for downloaded movies as `/plexmedia/Movies`!

## Todo
- Automate post-installation steps
- Include domain name support with automatic SSL certificate creation from Let's Encrypt

## Known Issues
- Some kind of race condition exists in whereby `apt-get update` sometimes doesn't finish before `apt-get install aptdcon` is triggered, causing the installation to fail entirely. 
- Google Cloud support is very close but still experiencing errors during initial setup. However, once these errors occur, exiting out of the terraform shell with `ctrl+c` and re-running `terraform apply` seems to make this depoyment successful.
- Any help with these would be greatly appreciated!

## Services

- Plex (Media) - if remote management enabled, access at `http://<machine_ip>:32400/web`

- Sonarr (TV) - `http://<machine_ip>/sonarr`

- Radarr (Movies) - `http://<machine_ip>/radarr`

- SABnzbd (Downloader) - `http://<machine_ip>/sabnzbd`
