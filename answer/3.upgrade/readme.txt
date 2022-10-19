#### Upgrade
#将节点标记为不可调度状态
# kubectl cordon master01 

#驱逐节点上面的pod
# kubectl drain master01 --delete-emptydir-data --ignore-daemonsets --force 

#升级组件
$ apt-get install kubeadm=1.21.1-00 kubelet=1.21.1-00 kubectl=1.21.1-00
#或者 
# apt-get install -y --allow-change-held-packages kubeadm=1.21.1-00
# apt-get install -y --allow-change-held-packages kubelet=1.21.1-00 kubectl=1.21.1-00

#重启kubelet服务
# systemctl restart kubelet

#升级集群其他组件
# kubeadm upgrade apply v1.21.1

#恢复调度
# kubectl uncordon master01


# 实际操作失败，拉取得国外镜像，可以将镜像从国内拉取下来，再改成国外镜像名称
