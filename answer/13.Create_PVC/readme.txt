# 在官网文档中搜索PV, 找到模板，根据题意修改名字，容量等
# 中文文档: 配置Pod 以使用PersistentVolume 作为存储| Kubernetes
# 英文文档: Configure a Pod to Use a PersistentVolume for Storage | Kubernetes

# 先创建PV(考试环境自带)，用于测试
vim PV.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: csi-hostpath-sc
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"


# 开始，创建PVC，name是pv-volume,class是csi-hostpath-sc,Capacity: 10Mi
vim PVC.yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-volume
spec:
  storageClassName: csi-hostpath-sc   # 与PV一致
  accessModes:
    - ReadWriteOnce                   # 与PV一致
  resources:
    requests:
      storage: 10Mi                   # 这里虽然是10Mi,但是由于PV不是动态的，所以无法改变大小，考试环境自带的PV应该是动态的

# PV和PVC部署后,status是bound则成功
kubectl get pv,pvc

NAME                              CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS      REASON   AGE
persistentvolume/task-pv-volume   1Gi        RWX            Retain           Bound    default/pvc-volume   csi-hostpath-sc            22m

NAME                               STATUS   VOLUME           CAPACITY   ACCESS MODES   STORAGECLASS      AGE
persistentvolumeclaim/pvc-volume   Bound    task-pv-volume   1Gi        RWX            csi-hostpath-sc   22m


# 创建一个pod挂载PVC
vim pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: web-server
spec:
  volumes:
    - name: pv-volume
      persistentVolumeClaim:
        claimName: pv-volume
  containers:
    - name: web-server
      image: nginx
      ports:
        - containerPort: 80
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: pv-volume

# 使用kucectl edit 或者kubectl patch命令去将PVC扩容为70Mi，失败，不支持NFS扩展
# 仅允许AWS-EBS, GCE-PD, Azure Disk, Azure File, Glusterfs, Cinder, Portworx, and Ceph RBD.

# 部署pod后验证，查看运行在那个node上，该node的/mnt/data将挂载进pod，因为下面没有index.html所以访问会报错403
# 在/mnt/data下创建index.html,再次访问，成功
curl pod_ip
