# 在官网文档中搜索PV, 找到模板，根据题意修改名字，容量等
# 中文文档: 配置Pod 以使用PersistentVolume 作为存储| Kubernetes
# https://kubernetes.io/zh/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
# 英文文档: Configure a Pod to Use a PersistentVolume for Storage | Kubernetes

apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-config
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany  #
  hostPath:
    path: "/src/app-config"
