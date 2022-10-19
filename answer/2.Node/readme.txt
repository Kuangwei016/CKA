# 将名为ek8s-node-1的node设置为不可用，并且重新调度该node上所有允许的pods

# 将node02标注为不可调度
kubectl cordon node02

# 将node02上面的非daemonsets pod重新调度到其它node上, --delete-emptydir-data取代了--delete-loacl-data(1.19)
kubectl drain node02 --delete-emptydir-data --ignore-daemonsets --force
