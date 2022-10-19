# 将pod名称为nginx-kusc00401,pod镜像名称为nginx，部署到标签为disk=ssd的node节点上

# 查询node标签
kubectl get node -o wide --show-labels 

# 手动给node02打上标签disk=ssd
kubectl labels nodes node02 disk=ssd

# 生成pod模板，指定名字，镜像等
kubectl run nginx-kusc00401 --image=nginx --port=80 --dry-run=client -o yaml > pod.yml

# 修改模板，增加nodeSelector
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx-kusc00401
  name: nginx-kusc00401
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx-kusc00401
    ports:
    - containerPort: 80
  nodeSelector:        # 这两行是增加的
    disk: ssd

# 验证，apply后, 检查pod是否跑在node02上
kubectl get pod -A -o wide
