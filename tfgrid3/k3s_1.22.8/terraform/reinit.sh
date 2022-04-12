#!/bin/bash
sudo wg-quick down test1
terraform destroy --auto-approve --parallelism=1
terraform apply --auto-approve --parallelism=1
terraform output wg_config | sed '1,2d' | sed '$d' > test1.conf
sudo cp -f test1.conf /etc/wireguard
sudo wg-quick up test1
echo Pause de 20 secondes...
sleep 20
scp root@10.13.3.2:/etc/rancher/k3s/k3s.yaml ~/.kube/config
sed -i 's/127.0.0.1/10.13.3.2/' ~/.kube/config
kubens kube-system
kubectl get node --show-labels
kubectl get pod -o wide --all-namespaces
