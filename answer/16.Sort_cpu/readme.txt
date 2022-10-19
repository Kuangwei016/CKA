# 使用Kubectl top pod命令时报错，没有安装metric-server组件导致的
# wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# 修改image改为阿里云
# 取消验证证书
template:
    metadata:
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=443
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        - --metric-resolution=15s
        - --kubelet-insecure-tls  # 添加不验证证书
        image: k8s.gcr.io/metrics-server/metrics-server:v0.5.0
        imagePullPolicy: IfNotPresent

————————————————

# 查找标签name=cpu-user的pod，使用cpu最高的podname写入指定文件
kubectl top pod -l name=cpu-user -A --sort-by=cpu
# 结果写入指定文件中
# echo "podname" >> /root/cka/name.txt
