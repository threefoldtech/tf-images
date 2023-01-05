echo "KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /etc/environment

if [ ! -z "${K3S_DATA_DIR}" ]; then
    echo "k3s data-dir set to: $K3S_DATA_DIR"
    mv -r /var/lib/rancher/k3s/* $K3S_DATA_DIR
    EXTRA_ARGS="--data-dir $K3S_DATA_DIR --kubelet-arg=root-dir=$K3S_DATA_DIR/kubelet"
fi

if [ -z "${K3S_FLANNEL_IFACE}" ]; then
    K3S_FLANNEL_IFACE=eth0
fi

if [ -z "${K3S_URL}" ]; then
    k3s server --flannel-iface $K3S_FLANNEL_IFACE $EXTRA_ARGS 2>&1 | tee -a /var/log/k3s-service.log 
else
    k3s agent --flannel-iface $K3S_FLANNEL_IFACE $EXTRA_ARGS 2>&1 | tee -a /var/log/k3s-service.log
fi
