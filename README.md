# ZOS Images

A curated collection of container images and flists packaged for deployment on decentralized infrastructure. It provides pre-configured workloads including operating system distributions, databases, web servers, orchestrators, and blockchain nodes optimized for the grid environment.

## What this is

This repository maintains the build recipes, Dockerfiles, and packaging logic for official workload images. Each image is built as a container and converted to an flist — a lightweight, immutable filesystem image format used for fast provisioning. The repository serves as the source of truth for grid-supported application and OS images.

## What this repository contains

- **Operating system images** — Alpine, Arch, CentOS Stream, Debian, Ubuntu (20.04, 22.04, 24.04), NixOS, Umbrel
- **Application images** — Discourse, Taiga, WordPress, Gitea, Peertube, Jenkins, Jitsi, Mattermost, Nextcloud, Owncloud, Funkwhale, Static websites, and more
- **Orchestrator images** — K3s for lightweight Kubernetes deployment
- **Blockchain node images** — Algorand, Casper, Nostr relay, Presearch
- **Supporting utilities** — Entrypoint scripts, initialization logic, and packaging tools

## Role in the stack

These images are consumed by the grid deployment layer. When a user requests a workload, the grid fetches the corresponding flist and bootstraps it on the target node. The images are designed to run on ZOS / Zero-OS nodes with minimal overhead and fast startup times.

## ZOS / Zero-OS

ZOS, also known as Zero-OS, is the operating system layer used to run and manage nodes. It provides the low-level runtime environment for workloads, networking, storage, and automation. The images in this repository are packaged specifically to run within the ZOS environment.

## Relation to ThreeFold

This technology is used within the ThreeFold ecosystem and was first deployed on the ThreeFold Grid. The component itself is designed as reusable infrastructure technology and should be understood by its technical function first, independent of any specific deployment.

## Ownership

This repository is owned and maintained by TF-Tech NV, a Belgian company responsible for the development and maintenance of this technology.

## Examples

### Applications

| Application | Dockerfile | Flist |
|-------------|------------|-------|
| Discourse | [discourse](./tfgrid3/forum-3/README.md) | https://hub.grid.tf/tf-official-apps/forum.flist |
| Taiga | [taiga](./tfgrid3/taiga/README.md) | https://hub.grid.tf/tf-official-apps/grid3_taiga_docker-latest.flist |
| WordPress | [wordpress](./tfgrid3/wordpress/README.md) | https://hub.grid.tf/tf-official-apps/tf-wordpress-latest.flist |
| Gitea (Mycelium) | [gitea](./tfgrid3/gitea_mycelium/README.md) | https://hub.grid.tf/tf-official-apps/gitea-mycelium.flist |
| Peertube | [peertube](./tfgrid3/peertube/README.md) | https://hub.grid.tf/tf-official-apps/peertube-latest.flist |

### Orchestrators

| Orchestrator | Dockerfile | Flist |
|--------------|------------|-------|
| K3s | [K3S](./tfgrid3/k3s/README.md) | https://hub.grid.tf/tf-official-apps/threefolddev-k3s-v1.31.0.flist |

### Operating systems

| OS | Dockerfile | Flist |
|----|------------|-------|
| Ubuntu 20.04 | [Ubuntu 20.04](./tfgrid3/ubuntu20.04/README.md) | https://hub.grid.tf/tf-official-vms/ubuntu-20.04-lts.flist |
| Ubuntu 22.04 | [Ubuntu 22.04](./tfgrid3/ubuntu22.04/fullvm/README.md) | https://hub.grid.tf/tf-official-vms/ubuntu-22.04.flist |
| Ubuntu 24.04 | [Ubuntu 24.04](./tfgrid3/ubuntu24.04/fullvm/README.md) | https://hub.grid.tf/tf-official-vms/ubuntu-24.04-full.flist |

## Entrypoints

### Operating systems

| Image | Flist | Entrypoint |
|-------|-------|------------|
| Alpine | https://hub.grid.tf/tf-official-apps/alpine3.flist | `/entrypoint.sh` |
| Arch (Mycelium) | https://hub.grid.tf/tf-official-apps/arch_mycelium.flist | `/sbin/zinit init` |
| CentOS Stream 9 | https://hub.grid.tf/tf-official-apps/centos-stream9.flist | `/entrypoint.sh` |
| Debian | https://hub.grid.tf/tf-official-apps/debian12.flist | `/sbin/zinit init` |
| Ubuntu 20.04 | https://hub.grid.tf/tf-official-vms/ubuntu-20.04-lts.flist | `/sbin/init.sh` |
| Ubuntu 22.04 micro-vm | https://hub.grid.tf/tf-official-vms/ubuntu-22.04.flist | `/sbin/zinit init` |
| Ubuntu 23.10 micro-vm | https://hub.grid.tf/tf-official-vms/ubuntu-23.10-mycelium.flist | `/sbin/zinit init` |
| Ubuntu 24.04 micro-vm | https://hub.grid.tf/tf-official-vms/ubuntu-24.04-latest.flist | `/sbin/zinit init` |
| Umbrel | https://hub.grid.tf/tf-official-apps/umbrel-latest.flist | `/sbin/zinit init` |
| NixOS micro-vm | https://hub.grid.tf/tf-official-vms/nixos-22.11.flist | `/entrypoint.sh` |

### Solutions

| Solution | Flist | Entrypoint |
|----------|-------|------------|
| Algorand | https://hub.grid.tf/tf-official-apps/algorand-latest.flist | `/sbin/zinit init` |
| Casper | https://hub.grid.tf/tf-official-apps/casperlabs-latest.flist | `/sbin/zinit init` |
| Caprover | https://hub.grid.tf/tf-official-apps/tf-caprover-latest.flist | `/sbin/zinit init` |
| Forum-3 | https://hub.grid.tf/tf-official-apps/forum.flist | `/sbin/zinit init` |
| Funkwhale | https://hub.grid.tf/tf-official-apps/funkwhale-1.4.0.flist | `/sbin/zinit init` |
| Gitea (Mycelium) | https://hub.grid.tf/tf-official-apps/gitea-mycelium.flist | `/sbin/zinit init` |
| Jenkins | https://hub.grid.tf/tf-official-apps/jenkins-latest.flist | `/sbin/zinit init` |
| Jitsi | https://hub.grid.tf/tf-official-apps/jitsi-latest.flist | `/sbin/zinit init` |
| K3s | https://hub.grid.tf/tf-official-apps/threefolddev-k3s-v1.31.0.flist | `/sbin/zinit init` |
| Mattermost | https://hub.grid.tf/tf-official-apps/mattermost-latest.flist | `/sbin/zinit init` |
| Nextcloud | https://hub.grid.tf/tf-official-apps/nextcloud.flist | `/sbin/zinit init` |
| Nodepilot | https://hub.grid.tf/tf-official-vms/node-pilot-zdbfs.flist | `/` |
| Nostr relay | https://hub.grid.tf/tf-official-apps/nostr_relay-mycelium.flist | `/sbin/zinit init` |
| Owncloud | https://hub.grid.tf/tf-official-apps/owncloud-10.9.1.flist | `/sbin/zinit init` |
| Peertube | https://hub.grid.tf/tf-official-apps/peertube-latest.flist | `/sbin/zinit init` |
| Presearch | https://hub.grid.tf/tf-official-apps/presearch.flist | `/sbin/zinit init` |
| Static website | https://hub.grid.tf/tf-official-apps/staticwebsite-latest.flist | `/sbin/zinit init` |
| Subsquid | https://hub.grid.tf/tf-official-apps/subsquid.flist | `/sbin/zinit init` |
| Taiga | https://hub.grid.tf/tf-official-apps/grid3_taiga_docker-latest.flist | `/sbin/zinit init` |
| TFRobot | https://hub.grid.tf/tf-official-apps/tfrobot.flist | `/sbin/zinit init` |
| WordPress | https://hub.grid.tf/tf-official-apps/tf-wordpress-latest.flist | `/sbin/zinit init` |

## Contribution

- Create a new branch for your work from the `development` branch.
- Push your work to your branch.
- Create a PR and ask for review from code owners.
- Once your PR is approved and merged, ask `@maxux` to promote your newly built flist.

## Issues

Please follow the issue templates in this repository when creating a new issue.

## License

This project is licensed under the Apache License 2.0 — see the [LICENSE](LICENSE) file for details.
Copyright (c) TFTech NV.
