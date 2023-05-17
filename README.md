# proton-irradiation-www
Website for proton irradiation station at IFJ PAN:
  - development version of the site: https://grzanka.github.io/nz62www/
  - production version of the site: https://www.ifj.edu.pl/dept/no6/nz62/www/

## Installation

This repository uses git submodules, therefore simple git clone operation may not be enough to get all contents.
Git submodules are used for Hugo static HTML generator theme.
Clone the repo:

```bash
git clone git@github.com:grzanka/nz62www.git --recursive
```

or
```bash
git clone git@github.com:grzanka/nz62www.git
git submodule update --init
```

Install Hugo:

```bash
sudo snap install hugo
```

or:

```bash
sudo apt install hugo
```

Generate the website:

```bash
cd nz62www
hugo
```

## Contents of the repository

The page is generated using [Hugo]https://gohugo.io). The repository contains:
- `content/` - directory with the content of the page in the Markdown format
- `config.toml` - configuration file for the Hugo generator
- `layouts` - custom layouts adjustments for the theme
- `themes` - directory with the customised Hugo docdock theme
- `.env` - file with enviroment variables for connection details to deploy site to IFJ server (server, username, path)
- `deploy.sh` - deploy script which builds the page and uploads it to IFJ server

Page layout is based on the [DocDock](https://docdock.vjeantet.fr) theme.

Github Actions (customised in `.github/workflows/`) are used to run automatic tests after every commit. 
These checks ensure that the page is generated correctly and that all links are valid.


## Deployment

LFTP deploy is handled by `deploy.sh` script. It assumes that necessary credentials are stored in the `.env` file of in the environment variables.
You can use it to deploy site to the IFJ web server.

## How to contribute

If you want to contribute to the page, please follow these steps:
1. Create new branch from the main `master` branch
2. Make changes in the new branch
3. Create pull request to the `master` branch
4. Wait for the review and merge. Once the pull requests is merged, Github Actions will automatically deploy the page to https://grzanka.github.io/nz62www/
