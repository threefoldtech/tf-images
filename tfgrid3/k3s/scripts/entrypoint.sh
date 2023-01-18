echo "KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /etc/environment

if [ ! -z "${K3S_DATA_DIR}" ]; then
    echo "k3s data-dir set to: $K3S_DATA_DIR"
    cp -r /var/lib/rancher/k3s/* $K3S_DATA_DIR && rm -rf /var/lib/rancher/k3s
    EXTRA_ARGS="--data-dir $K3S_DATA_DIR --kubelet-arg=root-dir=$K3S_DATA_DIR/kubelet"
fi

if [ -z "${K3S_FLANNEL_IFACE}" ]; then
    K3S_FLANNEL_IFACE=eth0
fi

if [ -z "${K3S_URL}" ]; then
    exec k3s server --flannel-iface $K3S_FLANNEL_IFACE $EXTRA_ARGS 2>&1
else
    exec k3s agent --flannel-iface $K3S_FLANNEL_IFACE $EXTRA_ARGS 2>&1
fi
