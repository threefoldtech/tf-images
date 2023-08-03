<h1> Debian Bookworm 12 </h1>

<h2> Table of Contents </h2>

- [Introduction](#introduction)
- [Building](#building)
- [Testing](#testing)
  - [Running](#running)
  - [Access using SSH](#access-using-ssh)
- [Deploying on Grid 3](#deploying-on-grid-3)
  - [Convert the Docker Image to Zero-OS FList](#convert-the-docker-image-to-zero-os-flist)
  - [Quick Deployment](#quick-deployment)
    - [Playground Deployment Steps](#playground-deployment-steps)
- [FList](#flist)
  - [URL:](#url)
  - [Entrypoint](#entrypoint)
  - [Required Env Vars](#required-env-vars)

***

# Introduction

This Debian FList is based on the official docker image of Debian v.12 (Bookworm). It includes the preinstalled `openssh-server` package.

# Building

In the debian-12 directory:

`docker build -t {user|org}/grid3_debian:12 .`
***
# Testing
## Running

```bash
docker run -dti -e SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." {user|org}/grid3_debian:12
```

## Access using SSH

```bash
CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker container ls -lq))
ssh root@$CONTAINER_IP
```
***
# Deploying on Grid 3

## Convert the Docker Image to Zero-OS FList

The easiest way to convert the docker image to an FList is by using the [Docker Hub Converter Tool](https://hub.grid.tf/docker-convert). Make sure that you've already built and pushed the docker image to docker hub before using this tool.

Note that a docker image has already been converted to an FList:

```
https://hub.grid.tf/ahmedthabet.3bot/threefolddev-debian-12.flist
```

## Quick Deployment

The easiest way to deploy a micro VM using the Debian FList is to head to to the [ThreeFold Playground](https://play.grid.tf) and deploy a [Micro Virtual Machine](https://play.grid.tf/#/vm) by providing the Debian FList URL.

Make sure to provide the correct entrypoint (`/sbin/zinit init`). Note that the entrypoint should already be set by default when you open the micro VM page.

You could also use Terraform instead of the Playground to deploy the Debian Micro VM. Read more on this [here](https://github.com/threefoldtech/terraform-provider-grid).

### Playground Deployment Steps

* Go to the [ThreeFold Playground](https://play.grid.tf)
* Set your profile manager
* Go to the [Micro VM](https://play.grid.tf/#/vm) page
* Choose your parameters (name, VM specs, etc.)
* Enter the Debian FList under `FList`:
  * ```
    https://hub.grid.tf/ahmedthabet.3bot/threefolddev-debian-12.flist
    ```
* Make sure the entrypoint is as follows:
  * ```
    /sbin/zinit init
    ```
* Choose a 3Node to deploy on
* Click `Deploy`
***

# FList

## URL:

```
https://hub.grid.tf/ahmedthabet.3bot/threefolddev-debian-12.flist
```

## Entrypoint
```
/sbin/zinit init
```

## Required Env Vars

* `SSH_KEY`: User SSH public key.
  * This should be set in your profile manager.