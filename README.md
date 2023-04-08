# kivitendo_docker

Docker Build for Kivitendo erp solution for small businesses


## Table of Contents

- [Introduction](#introduction)
- [Changelog](Changelog.md)
- [Contributing](#contributing)
- [Reporting Issues](#issues)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Build container from Dockerfile](#build)
- [Upgrading](#upgrading)
- [Using Docker-Compose](#docker-compose)

## <a name="introduction"></a>Introduction

Dockerfile to build a Kivitendo container image which can be linked to other containers.
Will install Apache2 and all the necessary packages for Kivitendo.

## <a name="contributing"></a>Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/atl285/kivitendo_docker/issues) they may encounter

## <a name="issues"></a>Reporting Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

For ubuntu users I suggest [installing docker](https://docs.docker.com/installation/ubuntulinux/) using docker's own package repository since the version of docker packaged in the ubuntu repositories are a little dated.

Here is the shortform of the installation of an updated version of docker on ubuntu.

```bash
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install docker-ce docker-compose-plugin
```

## <a name="installation"></a>Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull atl285/kivitendo-docker
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/atl285/kivitendo_docker.git
cd kivitendo_docker
docker build --build-arg "VERSION=3.8.0" -t="<name_of_your_container>" ./docker/ 
```

## <a name="quick-start"></a>Quick Start

Run the postgres image

```bash
docker run --name kivitendo_db -d -e "POSTGRES_USER=docker" -e "POSTGRES_PASSWORD=docker" -e "POSTGRES_DB=kivitendo_auth" -e "LANG=de_DE.utf8" -p 5432:5432 postgres:11.19-alpine
```

Run the Kivitendo image

```bash
docker run --name <name_of_your_container> -d atl285/kivitendo-docker
```

Check the ip of your docker container

```bash
docker ps -q | xargs docker inspect | grep IPAddress | cut -d '"' -f 4
```

Got to the administrative interface of kivitendo using the password: admin123 and configure the database. All database users (kivitendo and docker) use docker as password.

## <a name="configuration"></a>Configuration

### Data Store

For data persistence a volume should be mounted at `/var/lib/postgresql`.

The updated run command looks like this.

```bash
docker run --name kivitendo_db -d -e "POSTGRES_USER=docker" -e "POSTGRES_PASSWORD=docker" -e "POSTGRES_DB=kivitendo_auth" -e "LANG=de_DE.utf8" -p 5432:5432 -v /opt/postgresql/data:/var/lib/postgresql postgres:11.19-alpine
```

This will make sure that the data stored in the database is not lost when the image is stopped and started again.

### Securing the server

By default 'docker' is assigned as password for the postgres user.

## <a name="build"></a>Build container from Dockerfile

You can build the container from the Dockerfile in
https://github.com/atl285/kivitendo_docker

simply clone the git repo localy and then build

```bash
git clone https://github.com/atl285/kivitendo_docker.git
cd kivitendo_docker
sudo docker build --build-arg "VERSION=3.8.0" -t="<name_of_your_container>" ./docker/
```

## <a name="upgrading"></a>Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```bash
docker stop <name_of_your_container>
```

- **Step 2**: Update the docker image.

```bash
docker pull drnoa/kivitendo-docker:latest
```

- **Step 3**: Start the image

```bash
docker run --name <name_of_your_container> -d [OPTIONS] drnoa/kivitendo-docker:latest
```

## <a name="docker-compose"></a>Using Docker-Compose

The repository contains a `docker-compose.yml` to setup all the needed stuff. This is more user friendly.

### Configuration

Create a copy of `env.tmpl` in the same directory, rename it to `.env` and edit the content to your needed values. The env file contains all needed values with generic unsecure values:

```file
# Kivitendo release version (without 'release-')
RELEASE_TAG="3.8.0"

# admin password web interface
ADMIN_PASSWORD=admin123

# postgres database connection
POSTGRES_VERSION="11.19-alpine"
DB_HOST=db
DB_PORT=5432
DB_DBNAME=kivitendo_auth
DB_USER=docker
DB_PASSWORD=docker

# mail server configuration 
# SMTP port is choosen based on SMTP security (none, tls, ssl)
# and should only used if value is not standard
SMTP_HOST=localhost
SMTP_PORT=
SMTP_SECURITY=none
SMTP_USER=
SMTP_PASSWORD=
```

### Build and run

The you can build the Kivitendo container with the command: `docker compose build`

To start all the containers, run: `docker compose up -d`

To stop the containers, run: `docker compose down`

And to check for running or state, use: `docker compose ps`

### Database management

for access the database via external frontend **pgAdmin4** can be installed beside the PostgreSQL container by inserting the following lines below the postgres container defintions:

```yaml
  pgadmin:
    container_name: pgadmin4
    image: dpage/pgadmin4
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: root
    ports:
      - "5050:80"
```

The webinterface of the pgAdmin4 can be accessed via http://localhost:5050.

### Upgrading

Change RELEASE_TAG value in `.env` file to the requested version (e.g. "3.8.0"). The run the following commands:

```bash
docker compose build
docker compose up -d
```

This will build the new container and afterwards (only) the Kivitendo container will recreated and restarted.
