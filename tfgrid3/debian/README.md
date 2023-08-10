<h1> Debian Bookworm 12 </h1>

<h2> Table of Contents </h2>

- [Introduction](#introduction)
- [Convert the Docker Image to Zero-OS FList](#convert-the-docker-image-to-zero-os-flist)
- [Deployment](#deployment)
  - [Playground Steps](#playground-steps)

***

# Introduction

This Debian FList is based on the official docker image of Debian v.12 (Bookworm). It includes the preinstalled `openssh-server` package.
***

# Convert the Docker Image to Zero-OS FList

The easiest way to convert the docker image to an FList is by using the [Docker Hub Converter Tool](https://hub.grid.tf/docker-convert). This can be done once you've built and pushed the docker image on the [Docker Hub](https://hub.docker.com/).

Note that a docker image has already been converted to an FList (see below).
***
# Deployment

The easiest way to deploy a micro VM using the Debian FList is to head to to the [ThreeFold Playground](https://play.grid.tf) and deploy a [Micro Virtual Machine](https://play.grid.tf/#/vm) by providing the Debian FList URL.

Make sure to provide the correct entrypoint (`/sbin/zinit init`). Note that the entrypoint should already be set by default when you open the micro VM page.

You could also use Terraform instead of the Playground to deploy the Debian Micro VM. Read more on this [here](https://github.com/threefoldtech/terraform-provider-grid).

## Playground Steps

* Go to the [ThreeFold Playground](https://play.grid.tf)
* Set your profile manager
* Go to the [Micro VM](https://play.grid.tf/#/vm) page
* Choose your parameters (name, VM specs, etc.)
* Enter the Debian FList under `FList`:
  * ```
    https://hub.grid.tf/tf-official-apps/threefoldtech-debian-12.flist
    ```
* Make sure the entrypoint is as follows:
  * ```
    /sbin/zinit init
    ```
* Choose a 3Node to deploy on
* Click `Deploy`
