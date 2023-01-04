echo "KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /etc/environment

if [ -z "${K3S_DATA_DIR}" ]; then
    K3S_DATA_DIR=""
else
    cp -r /var/lib/rancher/k3s/* $K3S_DATA_DIR
    K3S_DATA_DIR="--data-dir $K3S_DATA_DIR --kubelet-arg=root-dir=$K3S_DATA_DIR/kubelet"
fi

if [ -z "${K3S_FLANNEL_IFACE}" ]; then
    K3S_FLANNEL_IFACE=eth0
fi

if [ "$K3S_URL" = "" ]; then
    k3s server --flannel-iface $K3S_FLANNEL_IFACE $K3S_DATA_DIR >> /var/log/k3s-service.log 2>&1
else
    k3s agent --flannel-iface $K3S_FLANNEL_IFACE $K3S_DATA_DIR >> /var/log/k3s-service.log 2>&1
fi
