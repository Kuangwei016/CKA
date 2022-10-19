# 文档地址: https://kubernetes.io/zh/docs/concepts/cluster-administration/logging/
# 概念->集群管理->日志架构
# 使用 sidecar 容器运行日志代理


# 已存在的pod 导出yml文件，去掉多余参数
kubectl get po legacy-app -o yaml > pod1.yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
spec:
  containers:
  - name: count
    image: busybox
    args:
    - /bin/sh
    - -c
    - >
      i=0;
      while true;
      do
        echo "$(date) INFO $i" >> /var/log/legacy-ap.log;
        i=$((i+1));
        sleep 1;
      done
    volumeMounts:
    - name: logs
      mountPath: /var/log
  volumes:
  - name: logs
    emptyDir: {}


# 先停止legacy-app pod
kubectl delete -f pod1.yml

# 复制一份pod2.yml,并通过文档，将sidecar添加进去
vim pod2.yml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - |
      i=0; while true; do
        echo "$(date) INFO $i" >> /var/log/legacy-ap.log;
        i=$((i+1));
        sleep 1;
      done
    image: busybox
    name: count
    volumeMounts:
    - mountPath: /var/log
      name: logs
  - name: count-log          # 这一段是添加的
    image: busybox
    args: [/bin/sh, -c, 'tail -n+1 -f /var/log/legacy-ap.log']
    volumeMounts:
    - name: logs
      mountPath: /var/log    # 到这里
  volumes:
  - emptyDir: {}
    name: logs

# 部署pod2.yml
kubectl apply -f pod2.yml

# 查看pod中的count-log容器日志
kubectl logs legacy-app -c count-log
