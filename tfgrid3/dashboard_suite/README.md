<h1> Dashboard Suite </h1>

<h2> Table of Contents </h2>

- [Introduction](#introduction)
  - [Networks](#networks)
- [Create the Docker Image](#create-the-docker-image)
- [Convert the Docker Image to Zero-OS FList](#convert-the-docker-image-to-zero-os-flist)
- [TFGrid Deployment](#tfgrid-deployment)
  - [Dashboard Steps](#dashboard-steps)
- [DNS Settings](#dns-settings)
- [Access the Dashboard Suite](#access-the-dashboard-suite)
- [Conclusion](#conclusion)

## Introduction

This Dashboard Suite Flist can be deployed on a micro VM on the ThreeFold Grid, either via the TF Dashboard, or Terraform. This FList uses `Ubuntu 22.04`. This Dashboard Suite Flist is based on the repository [grid_deployment](https://github.com/threefoldtech/grid_deployment). The TF Manual also contains documentation on the [Dashboard Suite](https://manual.grid.tf/documentation/developers/grid_deployment/grid_deployment_full_vm.html).

To simply deploy the available FList on the ThreeFold Dashboard, skip to [this section](#dashboard-steps).

<!--
Note that the official FList for the Dashboard Suite is the following:

```
https://hub.grid.tf/tf-official-apps/threefoldtech-dashboard_suite-latest.flist
```
-->

### Networks

This Flist can deploy the Dashboard Suite on either main, test or dev network.

To deploy the 3 network instances, mainnet, testnet and mainnet, you need to follow the same process for each network on a separate machine or at least on a different VM. 

This means that you can either deploy each network instance on 3 different machines, or you can also deploy 3 different VMs on the same machine, e.g. a dedicated node. Then, each VM will run a different network instance. In this case, you will certainly need a machine with NVME storage disk and modern hardware.

## Create the Docker Image

To create the the Dashboard Suite image, clone this repository, then build and push the image to the Docker Hub.

* Clone the repository:
  * ```
    git clone https://github.com/threefoldtech/tf-images
    ```
  * ```
    cd tf-images/tfgrid3/dashboard_suite
    ```
* Build the image:
  * ```
    docker build -t <docker_username>/dashboard_suite .
    ```
* Push the image to the Docker Hub:
  * ```
    docker push <your_username>/dashboard_suite
    ```
 


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


## TFGrid Deployment

The easiest way to deploy a micro VM using the Dashboard Suite FList is to head to to the [ThreeFold Dashboard](https://dashboard.grid.tf) and deploy a [Micro Virtual Machine](https://dashboard.grid.tf/#/deploy/virtual-machines/micro-virtual-machine/) by providing the FList URL. Make sure to select `IPv4` and `IPv6`.

Make sure to provide the correct entrypoint (`/sbin/zinit init`). Note that the entrypoint should already be set by default when you open the micro VM page. 

You could also use Terraform instead of the Dashboard to deploy the Dashboard Suite Micro VM. Read more on this [here](https://github.com/threefoldtech/terraform-provider-grid).

### Dashboard Steps

* Go to the [ThreeFold Dashboard](https://dashboard.grid.tf)
* Log into your TF wallet
* Go to the [Micro VM](https://dashboard.grid.tf/#/deploy/virtual-machines/micro-virtual-machine/) page
* In the section `Config`, 
  * Choose a name for your VM under `Name`.
  * Under `VM Image`, select `Other`.
    * Enter the Dashboard Suite FList under `Flist`:
      * Template:
        * ```
          https://hub.grid.tf/<3BOT_name.3bot>/<docker_username>-<docker_image_name>-<tagname>.flist
          ```
      * Example:
        * ```
          https://hub.grid.tf/tf-official-apps/threefoldtech-dashboard_suite-latest.flist
          ```
  * Under `Entry Point`, the following should be set by default: `/sbin/zinit init`
  * `Select instance capacity` should be at 8 vcores, 50GB of SSD and 32GB of RAM.
  * Make sure that `IPv4` and `IPv6` are enabled (required).
* In the tab `Environment Variables`, click on the `plus` button then add 3 variables:
  * `DOMAIN` for `Name` and your domain (e.g. `example.com`) for `Value`.
  * `SEED` for `Name` and your TF seed phrase of the network you want to deploy the Dashboard Suite on (main, dev or test) (e.g. `main`) for `Value`.
* In the tab `Disks`, click on the `plus` button then add the disk:
  * `Name`: choose a name
  * `Size (GB)`: choose a size, minimum 750 GB
  * `Mount Point`: `/mnt/disk`
* Click `Deploy`.

## DNS Settings

You need to set an A record for the IPv4 address and an AAAA record for the IPv6 address with a wildcard subdomain.

The following table explicitly shows how to set the A and AAAA records for your domain for all 3 networks. Note that both `testnet` and `devnet` have a subdomain. The last two lines are for mainnet since no subdomain is needed in this case.

| Type | Host | Value          |
| ---- | ---- | -------------- |
| A    | \*.dev   | <devnet_ipv4_address> |
| AAAA | \*.dev  | <devnet_ipv6_address> |
| A    | \*.test   | <testnet_ipv4_address> |
| AAAA | \*.test  | <testnet_ipv6_address> |
| A    | \*  | <mainnet_ipv4_address> |
| AAAA | \*  | <mainnet_ipv6_address> |

As stated above, each network instance must be on its own VM or machine to work properly. Make sure to adjust the DNS records accordingly.

## Access the Dashboard Suite

You can now access the Dashboard Suite at the associated domains:

```
dashboard.example.com
metrics.example.com
tfchain.example.com
graphql.example.com
relay.example.com
gridproxy.example.com
activation.example.com
stats.example.com
```

## Conclusion

We've seen the overall process of creating a new FList to deploy a Dashboard Suite workload on a Micro VM on the ThreeFold Dashboard.

If you have any questions or feedback, please let us know by either writing a post on the [ThreeFold Forum](https://forum.threefold.io/), or by chatting with us on the [TF Grid Tester Community](https://t.me/threefoldtesting) Telegram channel.