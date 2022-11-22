# how to build nixos image

1. install nixpkgs or have a nixos machine [here](https://nixos.org/download.html)
2. clone [nixos-generators](https://github.com/threefoldtech/nixos-generators) repo
3. switch to branch `qcow-efi` if qcow-efi not yet on master
4. Create myimage.nix

```
{ pkgs, modulesPath, lib, ... }: {

   services.cloud-init = {
      enable = true;
      network.enable = true;
    };
  services.openssh = {
  enable = true;
};
system.stateVersion="22.11";
}
```

4. build the image `./nixos-generate -f qcow-efi -c myimage.nix -o result -I nixpkgs=channel:nixos-22.11` replace `nixos-22.11` with your desired version
5. install `qmeu-utils` to convert the image from qcow2 to efi `sudo apt-get install qemu-utils`
6. convert the image to raw format `qemu-img convert -p -f qcow2 -O raw result/nixos.qcow2 image.raw`
7. test it using [cloud hypervisor](https://github.com/cloud-hypervisor/cloud-hypervisor) to make sure it is working
8. create cloud init as described [here](https://github.com/cloud-hypervisor/cloud-hypervisor/blob/main/scripts/create-cloud-init.sh) and make sure to change the login shell to /bin/sh in user-data
9. run the cloud hypervisor to test ur config

```
./cloud-hypervisor --kernel ./hypervisor-fw --disk path=image.raw path=cloudinit.img --cpus boot=4 --memory size=1024M --net "tap=,mac=12:34:56:78:90:ab,ip=,mask=" --console off --serial tty
```

10. In case you faced the no space left on device issue make sure to do the steps decribed [here](https://github.com/threefoldtech/nixos-generators#no-space-left-on-device)

### Note:

don't push the file you tested with because it will be modified by cloud-init you will need to reconvert the qcow2 file again to obtain clean raw file

# pushing image to hub

1. tar your image.raw `image.raw` name is mandatory for your image to be detected as a full vm

```
tar -czf nixos-22.11.tar.gz image.raw
```

2. Either you upload ur image directly to the hub form browser or curl if you don't have a browser on the build machine

```
curl -f -X POST -H "Authorization: bearer <API TOKEN>" -F file=@nixos-22.11.tar.gz https://hub.grid.tf/api/flist/me/upload
```

