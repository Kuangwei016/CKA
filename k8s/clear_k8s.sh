#!/bin/bash

kubeadm reset

ifconfig cni0 down
ip link delete cni0
ifconfig flannel.1 down
ip link delete flannel.1
rm -rf $HOME/.kube
rm -rf /var/lib/cni/
apt-get install kubeadm=1.21.0-00  kubelet=1.21.0-00 kubectl=1.21.0-00

# 初始化集群
# kubeadm init --apiserver-advertise-address=192.168.1.11 --image-repository registry.aliyuncs.com/google_containers  --kubernetes-version=v1.21.0 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=CpuNum
# 部署CNI网络,当coreDNS起不来时
# kubectl apply -f kube-flannel.yml
# 部署ingress-controller
# kubectl apply -f ingress_deamonset_v1.1.1.yaml
