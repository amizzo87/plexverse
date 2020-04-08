# Plex in Google Cloud

Get Plex + Sonarr + Radarr + SABnzbd automatically installed in Google Cloud, with near-infinite (and affordable) storage provided by Google Nearline Storage. 

Automated deployment using [Terraform](https://www.terraform.io)

## Prerequisites

- Create a Google Cloud Platform Account
  - Create a new project, taking note of the project ID
  - Get authentication JSON file:
    - Log into [Google Developers Console](https://console.developers.google.com/), select your project
    - From the left hand side menu, select IAM & Admin, then choose "Credentials" from the menu, then "Create Credentials," then finally "Service Account Key"
    - Select "Compute Engine default service account" in the "Service Account" dropdown, select "JSON" as key type
    - Click "Create" to download the credentials to a path you'll enter in `config.ts`

- A Usenet account - [NewsgroupNinja](https://www.newsgroup.ninja/) recommended

- A Usenet indexer - [NZBGeek](https://nzbgeek.info) recommended

- Install Terraform from [terraform.io](https://www.terraform.io/downloads.html) or Homebrew (for Mac) with `brew install terraform`

- Generate SSH keys as follows:

  ```
  ssh-keygen -f ~/.ssh/gcloud_id_rsa

  press <Enter> when asked (twice) for a pass-phrase
  ```

## Installation

1. `git clone` this repo (duh).
2. Copy `config.tf.sample` to `config.tf` and modify/uncomment variables as necessary with your specific information.
3. Run `terraform plan` to make sure everything looks good
4. Run ` terraform apply` to deploy to Google Cloud
5. During the installation, you'll be prompted to authorize with Google by entering a code at [google.com/device](https://www.google.com/device). **Make sure to keep an eye out for this prompt in the terminal!**
6. Upon completion, note the output public IP address of the created machine to associate with a domain as you prefer.

## Post-Installation 

Please perform these configurations in the order listed.

### Plex

1. You need to create an SSH tunnel to access Plex for the initial set up. To do this, run `ssh -i ~/.ssh/gcloud_id_rsa root@<machine_ip> -L 8888:localhost:32400`. You'll then need to use it by going to `localhost:8888/web` and manually enable remote management for Plex (**v. important!**).
2. Add a Movies library in Plex and point it to `/cloud1/Movies`
3. Add a TV Shows libarary in Plex and point it to `/cloud1/TV Shows`

### SABnzbd

1. Go to `http://<machine_ip>:8080` and complete the intial set up (including adding your Usenet server credentials), taking note to create a username and password for security purposes.
2. Go to SABnzbd config at `http://<machine_ip>:8080/config/folders/`, and set "Temporary Download Folder" to `/home/downloads/sabnzbd/incomplete` and the "Completed Download Folder" to `/home/downloads/sabnzbd/complete`.
3. On this same config page, take note of the "API Key." You'll need to enter this in both Sonarr and Radarr in the next steps.

### Sonarr

1. Go to `http://<machine_ip>:8989` then to "Settings."
2. On the "Media Management" tab, change "Rename Episodes" to "Yes."
3. On the "Indexers" tab, add your preferred Usenet indexer settings and API key.
4. On the "Download Client" tab, add "SABnzbd" with the username/password and API key you received from the "SABnzbd" step of configuration above.
5. On the "General" tab, change "Authentication" to "Basic (Browser popup)" and enter a username and password. Click "Save."
6. Go to the "System" icon and restart Sonarr using the restart icon in the upper right corner of the frame.
7. Add your first TV series to Sonar. Under "Path," click "Add a different path" and browse to select `/cloud1/TV Shows`. This will now be the default for future shows you add.
8. Click the plus sign to add the show, then visit the page for the show you just added in Sonarr, and click the magnifying glass, either for the whole series or a specific show/season, to trigger searching, downloading, and processing. 

### Radarr

1. Same as with Sonarr (above), except make sure to add the path for downloaded movies as `/cloud1/Movies`!



## TODO

- Clean up code (~)
- Improve security (.)
- Automate post-installation steps (!)
- Add torrent support (!)
- Expand to more cloud providers (?)

## Services

- Plex (Media) - if remote management enabled, access at `http://<machine_ip>:32400/web`

- Sonarr (TV) - `http://<machine_ip>:8989`

- Radarr (Movies) - `http://<machine_ip>:7878`

- SABnzbd (Downloader) - `http://<machine_ip>:8080`

  ​
