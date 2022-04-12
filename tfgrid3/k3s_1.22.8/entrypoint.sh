#!/bin/bash

# Setting log directory if not defined by env var

# Getting ip from eth0

ip=$(ip a | grep "scope global eth0" | cut -d" " -f 6)
ip="${ip::-3}"

# Creating missing directories for SSHD and logs ; then starting services

mkdir -p /root/.ssh/ /run/sshd $LOG_DIRECTORY
echo $SSH_KEY > /root/.ssh/authorized_keys

service ssh start

# Generating hosts files

echo $K3S_NODE_NAME > /etc/hostname
echo 127.0.0.1 localhost > /etc/hosts
echo $ip $K3S_NODE_NAME >> /etc/hosts

# Initializing optional arguments

SERVER_ARGS=""
AGENT_ARGS=""

# Specifying a log directory

if [ -z "${LOG_DIRECTORY}" ]; then
  LOG_DIRECTORY="/var/log/rancher"
fi

SERVER_ARGS+="-l $LOG_DIRECTORY/k3s-$K3S_NODE_NAME.log "
AGENT_ARGS+="-l $LOG_DIRECTORY/k3s-$K3S_NODE_NAME.log "

# Specifying a taint to server nodes, so it will run only control-plane contrainers

if [ -n "${SERVER_NODE_ONLY_CONTROL_PLANE}" ]; then
  SERVER_ARGS+="--node-taint node-role.kubernetes.io/master=effect:NoSchedule "
fi

# Applying data dir

if [ -n "${K3S_DATA_DIR}" ]; then
  SERVER_ARGS+="--data-dir $K3S_DATA_DIR "
  AGENT_ARGS+="--data-dir $K3S_DATA_DIR "
fi

# Applying additional parameters if $HARDENED is defined
# Parameters from https://rancher.com/docs/k3s/latest/en/security/hardening_guide/#ensure-protect-kernel-defaults-is-set
# PodSecurityPolicy was removed due to being deprecated : https://kubernetes.io/blog/2021/04/06/podsecuritypolicy-deprecation-past-present-and-future/

if [ -n "${HARDENED}" ]; then

  # Hardening kernel parameters

  sysctl -w vm.panic_on_oom=0 vm.overcommit_memory=1 kernel.panic=10 kernel.panic_on_oops=1

  SERVER_ARGS+="--secrets-encryption=true \
    --protect-kernel-defaults=true \
    --kube-apiserver-arg=audit-log-path=$LOG_DIRECTORY/audit-log \
    --kube-apiserver-arg=audit-log-maxage=30 \
    --kube-apiserver-arg=audit-log-maxbackup=10 \
    --kube-apiserver-arg=audit-log-maxsize=100 \
    --kube-apiserver-arg=request-timeout=300s \
    --kube-apiserver-arg=service-account-lookup=true \
    --kube-apiserver-arg=enable-admission-plugins=NodeRestriction,NamespaceLifecycle,ServiceAccount \
    --kube-controller-manager-arg=terminated-pod-gc-threshold=10 \
    --kube-controller-manager-arg=use-service-account-credentials=true \
    --kubelet-arg=streaming-connection-idle-timeout=5m \
    --kubelet-arg=make-iptables-util-chains=true "

  AGENT_ARGS+="--kubelet-arg=streaming-connection-idle-timeout=5m \
    --kubelet-arg=make-iptables-util-chains=true \
    --kubelet-arg=protect-kernel-defaults=true "
fi

# Selecting installation type

if [ -z "${INSTALL_HA_SERVER}" ]; then
  if [ -z "${K3S_URL}" ]; then
    echo Starting mono node server
#    echo "/usr/bin/k3s server --tls-san $ip $SERVER_ARGS $ADDITIONAL_OPTIONS > /dev/null 2>&1"
    /usr/bin/k3s server --tls-san $ip $SERVER_ARGS $ADDITIONAL_OPTIONS > /dev/null 2>&1
  else
    echo Starting agent connecting to $K3S_URL
#    echo "/usr/bin/k3s agent  $AGENT_ARGS $ADDITIONAL_OPTIONS > /dev/null 2>&1"
    /usr/bin/k3s agent  $AGENT_ARGS $ADDITIONAL_OPTIONS > /dev/null 2>&1
  fi
else
    echo Starting HA server node
#    echo "/usr/bin/k3s server --cluster-init --datastore-endpoint etcd --etcd-expose-metrics  --tls-san $ip $SERVER_ARGS $ADDITIONAL_OPTIONS > /dev/null 2>&1"
    /usr/bin/k3s server --cluster-init --datastore-endpoint etcd --etcd-expose-metrics  --tls-san $ip $SERVER_ARGS $ADDITIONAL_OPTIONS > /dev/null 2>&1
fi
