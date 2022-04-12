terraform {
  required_providers {
    grid = {
      source = "threefoldtech/grid"
    }
  }
}

provider "grid" {
    mnemonics = "put your own words here"
    network = "test"
}

resource "grid_network" "netTest1" {
    nodes = [your node ID here,1]
    ip_range = "10.13.0.0/16"
    name = "netTest1"
    description = "selfHosting VM network"
    add_wg_access = true
}

resource "grid_deployment" "test1" {
  node = "your node ID here"
  network_name = grid_network.netTest1.name
  ip_range = grid_network.netTest1.nodes_ip_range["your node ID here"]
  disks {
    name = "server1Disk"
    size = 5
  }
  disks {
    name = "server2Disk"
    size = 5
  }
  disks {
    name = "server3Disk"
    size = 5
  }
  disks {
    name = "agent1Disk"
    size = 5
  }
  vms {
    name = "server1"
    flist = "https://hub.grid.tf/archit3kt.3bot/archit3kt-k3s-1.21.8.flist"
    cpu = 2
    publicip = false
    planetary = false
    memory = 4096
    entrypoint = "/sbin/zinit init"
    rootfs_size = 256
    mounts {
      disk_name = "server1Disk"
      mount_point = "/opt/data"
    }
    env_vars = {
      SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJPwvpAOUXA8Hfe0ZOQIGScbZBsCgs8c+YuqmycvAXubaUbsUGKyFE380t2A3q8oKpUTzOAhTVTYua5uCg6qO8b0vXi8m5wWhHSSSjOanefc1mKObTbmtJaFp8E1ascHdXWKXeDakpmTQ/sjo0VP+t/kTX5YU+/ZaS3/zsyrUGWRrNsU4o6YQ2J67rwf3VeTaDPpW+/n+WrzQEllvek0XJUgShbHkYoPzcZ0Wz275wdLm9GDk8Nja+ls2NLCszgxlaLy3AdEwLuCCl1wxExZKtgS3C63dEAjSbQCSCM7fK+8I0h0S5F8HSFLhaX1hCWYHNI/1X2DhXG6IIw+6lhhPrq+n5P22Omf2YvbBMIbi73piCJRql8ux6+TYt4zegXgrCSABN1Zue7KMTbvM9ae//3tLl/kdOWpJut/ojwk+pYTmYUjhZ9myy+RJagr3g9zq2qrzFk/fHHZJnEyTGqex36mUq2vEb8YtiaUQqf3hYf0SQJR7s8j12ECD+sNuE2L8= t3k@VM3"
      K3S_TOKEN = "djlksjdla2lewqldlks"
      K3S_NODE_NAME = "server1"
      K3S_DATA_DIR = "/opt/data"
      INSTALL_HA_SERVER = "y"
      ADDITIONAL_OPTIONS = ""
      HARDENED = "y"
      SERVER_NODE_ONLY_CONTROL_PLANE = "y"
    }
  }
  vms {
    name = "server2"
    flist = "https://hub.grid.tf/archit3kt.3bot/archit3kt-k3s-1.21.8.flist"
    cpu = 2
    publicip = false
    planetary = false
    memory = 4096
    entrypoint = "/sbin/zinit init"
    rootfs_size = 256
    mounts {
      disk_name = "server2Disk"
      mount_point = "/opt/data"
    }
    env_vars = {
      SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJPwvpAOUXA8Hfe0ZOQIGScbZBsCgs8c+YuqmycvAXubaUbsUGKyFE380t2A3q8oKpUTzOAhTVTYua5uCg6qO8b0vXi8m5wWhHSSSjOanefc1mKObTbmtJaFp8E1ascHdXWKXeDakpmTQ/sjo0VP+t/kTX5YU+/ZaS3/zsyrUGWRrNsU4o6YQ2J67rwf3VeTaDPpW+/n+WrzQEllvek0XJUgShbHkYoPzcZ0Wz275wdLm9GDk8Nja+ls2NLCszgxlaLy3AdEwLuCCl1wxExZKtgS3C63dEAjSbQCSCM7fK+8I0h0S5F8HSFLhaX1hCWYHNI/1X2DhXG6IIw+6lhhPrq+n5P22Omf2YvbBMIbi73piCJRql8ux6+TYt4zegXgrCSABN1Zue7KMTbvM9ae//3tLl/kdOWpJut/ojwk+pYTmYUjhZ9myy+RJagr3g9zq2qrzFk/fHHZJnEyTGqex36mUq2vEb8YtiaUQqf3hYf0SQJR7s8j12ECD+sNuE2L8= t3k@VM3"
      K3S_TOKEN = "djlksjdla2lewqldlks"
      K3S_NODE_NAME = "server2"
      K3S_DATA_DIR = "/opt/data"
      INSTALL_HA_SERVER = "y"
      K3S_URL="https://10.13.3.2:6443"
      ADDITIONAL_OPTIONS = ""
      HARDENED = "y"
      SERVER_NODE_ONLY_CONTROL_PLANE = "y"
    }
  }
  vms {
    name = "server3"
    flist = "https://hub.grid.tf/archit3kt.3bot/archit3kt-k3s-1.21.8.flist"
    cpu = 2
    publicip = false
    planetary = false
    memory = 4096
    entrypoint = "/sbin/zinit init"
    rootfs_size = 256
    mounts {
      disk_name = "server3Disk"
      mount_point = "/opt/data"
    }
    env_vars = {
      SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJPwvpAOUXA8Hfe0ZOQIGScbZBsCgs8c+YuqmycvAXubaUbsUGKyFE380t2A3q8oKpUTzOAhTVTYua5uCg6qO8b0vXi8m5wWhHSSSjOanefc1mKObTbmtJaFp8E1ascHdXWKXeDakpmTQ/sjo0VP+t/kTX5YU+/ZaS3/zsyrUGWRrNsU4o6YQ2J67rwf3VeTaDPpW+/n+WrzQEllvek0XJUgShbHkYoPzcZ0Wz275wdLm9GDk8Nja+ls2NLCszgxlaLy3AdEwLuCCl1wxExZKtgS3C63dEAjSbQCSCM7fK+8I0h0S5F8HSFLhaX1hCWYHNI/1X2DhXG6IIw+6lhhPrq+n5P22Omf2YvbBMIbi73piCJRql8ux6+TYt4zegXgrCSABN1Zue7KMTbvM9ae//3tLl/kdOWpJut/ojwk+pYTmYUjhZ9myy+RJagr3g9zq2qrzFk/fHHZJnEyTGqex36mUq2vEb8YtiaUQqf3hYf0SQJR7s8j12ECD+sNuE2L8= t3k@VM3"
      K3S_TOKEN = "djlksjdla2lewqldlks"
      K3S_NODE_NAME = "server3"
      K3S_DATA_DIR = "/opt/data"
      INSTALL_HA_SERVER = "y"
      K3S_URL="https://10.13.3.2:6443"
      ADDITIONAL_OPTIONS = ""
      HARDENED = "y"
      SERVER_NODE_ONLY_CONTROL_PLANE = "y"
    }
  }
  vms {
    name = "agent1"
    flist = "https://hub.grid.tf/archit3kt.3bot/archit3kt-k3s-1.21.8.flist"
    cpu = 2
    publicip = false
    planetary = false
    memory = 4096
    entrypoint = "/sbin/zinit init"
    rootfs_size = 256
    mounts {
      disk_name = "agent1Disk"
      mount_point = "/opt/data"
    }
    env_vars = {
      SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJPwvpAOUXA8Hfe0ZOQIGScbZBsCgs8c+YuqmycvAXubaUbsUGKyFE380t2A3q8oKpUTzOAhTVTYua5uCg6qO8b0vXi8m5wWhHSSSjOanefc1mKObTbmtJaFp8E1ascHdXWKXeDakpmTQ/sjo0VP+t/kTX5YU+/ZaS3/zsyrUGWRrNsU4o6YQ2J67rwf3VeTaDPpW+/n+WrzQEllvek0XJUgShbHkYoPzcZ0Wz275wdLm9GDk8Nja+ls2NLCszgxlaLy3AdEwLuCCl1wxExZKtgS3C63dEAjSbQCSCM7fK+8I0h0S5F8HSFLhaX1hCWYHNI/1X2DhXG6IIw+6lhhPrq+n5P22Omf2YvbBMIbi73piCJRql8ux6+TYt4zegXgrCSABN1Zue7KMTbvM9ae//3tLl/kdOWpJut/ojwk+pYTmYUjhZ9myy+RJagr3g9zq2qrzFk/fHHZJnEyTGqex36mUq2vEb8YtiaUQqf3hYf0SQJR7s8j12ECD+sNuE2L8= t3k@VM3"
      K3S_TOKEN = "djlksjdla2lewqldlks"
      K3S_NODE_NAME = "agent1"
      K3S_DATA_DIR = "/opt/data"
      K3S_URL="https://10.13.3.2:6443"
      HARDENED = "y"
    }
  }

}

output "wg_config" {
    value = grid_network.netTest1.access_wg_config
}

output "ip_wg" {
    value = grid_network.netTest1.public_node_id
}

output "server1" {
    value = grid_deployment.test1.vms[0].ip
}
output "server2" {
    value = grid_deployment.test1.vms[1].ip
}
output "server3" {
    value = grid_deployment.test1.vms[2].ip
}
output "agent1" {
    value = grid_deployment.test1.vms[3].ip
}
