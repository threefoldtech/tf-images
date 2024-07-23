<h1> Z-OS Boot Generator </h1>

<h2> Table of Contents </h2>

- [Introduction](#introduction)
- [Create the Docker Image](#create-the-docker-image)
- [Convert the Docker Image to Zero-OS FList](#convert-the-docker-image-to-zero-os-flist)
- [TFGrid Deployment](#tfgrid-deployment)
  - [Dashboard Steps](#dashboard-steps)
  - [Set the DNS Record for Your Domain](#set-the-dns-record-for-your-domain)
- [Access the Z-OS Bootstrap Generator](#access-the-z-os-bootstrap-generator)
- [Conclusion](#conclusion)

***

## Introduction

This Z-OS Boot Generator FList can be deployed on a micro VM on the ThreeFold Grid, either via the TF Dashboard, or Terraform. This FList uses `Ubuntu 22.04` and also includes the preinstalled `openssh-server` package. This FList  Z-OS Boot Generator is installed based on the latest Z-OS Boot Generator release from the Docker Hub.

To simply deploy the available FList on the ThreeFold Dashboard, skip to [this section](#dashboard-steps).

<!--
Note that the official FList for Z-OS Boot Generator is the following:

```
https://hub.grid.tf/tf-official-apps/threefoldtech-zos_boot_generator-latest.flist
```
-->

***

## Create the Docker Image

To create the the Z-OS Boot Generator image, clone this repository, then build and push the image to the Docker Hub.

* Clone the repository:
  * ```
    git clone https://github.com/threefoldtech/tf-images
    ```
  * ```
    cd tf-images/tfgrid3/zos_boot_generator
    ```
* Build the image:
  * ```
    docker build -t <docker_username>/zos_boot_generator .
    ```
* Push the image to the Docker Hub:
  * ```
    docker push <your_username>/zos_boot_generator
    ```
 
***

## Convert the Docker Image to Zero-OS FList

The easiest way to convert the docker image to an FList is by using the [Docker Hub Converter Tool](https://hub.grid.tf/docker-convert). This can be done once you've built and pushed the docker image on the [Docker Hub](https://hub.docker.com/).

> Note: A docker image has already been converted to an FList (see below).

* Go to the [ThreeFold Hub](https://hub.grid.tf/).
* Sign in with the ThreeFold Connect app.
* Go to the [Docker Hub Converter](https://hub.grid.tf/docker-convert) section.
* Next to `Docker Image Name`, add the docker image repository and name, see the example below:
  * Template:
    * `<docker_username>/docker_image_name:tagname`
* Click `Convert the docker image`.
* Once the conversion is done, the FList is available as a public link on the ThreeFold Hub.
* To get the FList URL, go to the [TF Hub main page](https://hub.grid.tf/), scroll down to your 3Bot ID and click on it.
* Under `Name`, you will see all your available FLists.
* Right-click on the FList you want and select `Copy Clean Link`. This URL will be used when deploying on the ThreeFold Dashboard. We show below the template and an example of what the FList URL looks like.
  * Template:
    * ```
      https://hub.grid.tf/<3BOT_name.3bot>/<docker_username>-<docker_image_name>-<tagname>.flist
      ```

***
## TFGrid Deployment

The easiest way to deploy a micro VM using the Z-OS Boot Generator FList is to head to to the [ThreeFold Dashboard](https://dashboard.grid.tf) and deploy a [Micro Virtual Machine](https://dashboard.grid.tf/#/deploy/virtual-machines/micro-virtual-machine/) by providing the FList URL. Make sure to select `IPv4`.

Make sure to provide the correct entrypoint (`/sbin/zinit init`). Note that the entrypoint should already be set by default when you open the micro VM page. 

You could also use Terraform instead of the Dashboard to deploy the Z-OS Boot Generator Micro VM. Read more on this [here](https://github.com/threefoldtech/terraform-provider-grid).

### Dashboard Steps

* Go to the [ThreeFold Dashboard](https://dashboard.grid.tf)
* Log into your TF wallet
* Go to the [Micro VM](https://dashboard.grid.tf/#/deploy/virtual-machines/micro-virtual-machine/) page
* In the section `Config`, 
  * Choose a name for your VM under `Name`.
  * Under `VM Image`, select `Other`.
    * Enter the Zero-OS Boot Generator FList under `Flist`:
      * Template:
        * ```
          https://hub.grid.tf/<3BOT_name.3bot>/<docker_username>-<docker_image_name>-<tagname>.flist
          ```
      * Example:
        * ```
          https://hub.grid.tf/tf-official-apps/threefoldtech-zos_boot_generator-latest.flist
          ```
  * Under `Entry Point`, the following should be set by default: `/sbin/zinit init`
  * `Select instance capacity` can be set at `Small` (1vcore, 2GB memory, 25GB SSd)
  * Make sure that `Public IPv4` is enabled (required).
* In the tab `Environment Variables`. Click on the `plus` button then add `DOMAIN` for `Name` and your domain (e.g. `example.com`) for `Value`.
* Click `Deploy`.

### Set the DNS Record for Your Domain

* Go to your domain name registrar (e.g. Namecheap)
  * In the section Advanced DNS, add a DNS A Record to your domain and link it to the VM IPv4 Address
    * Type: A Record
    * Host: @
    * Value: VM IPv4 Address
    * TTL: Automatic
  * It might take up to 30 minutes to set the DNS properly.
  * To check if the A record has been registered, you can use a common DNS checker:
    * ```
      https://dnschecker.org/#A/<domain-name>
      ```

## Access the Z-OS Bootstrap Generator

You can now access the Z-OS Bootstrap Generator at your domain, e.g. `https://example.com`.

## Conclusion

We've seen the overall process of creating a new FList to deploy a Z-OS Boot Generator workload on a Micro VM on the ThreeFold Dashboard.

If you have any questions or feedback, please let us know by either writing a post on the [ThreeFold Forum](https://forum.threefold.io/), or by chatting with us on the [TF Grid Tester Community](https://t.me/threefoldtesting) Telegram channel.
