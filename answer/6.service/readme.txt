# 创建一个测试用的deployment,image=nginx
kubectl create deployment front-end --image=nginx --replicas=1 --dry-run=client -o yaml > deployment.yml
kubectl apply -f deployment.yml

# 该deployment未配置端口，容器曝露一个80端口
kubectl edit deployment front-end 
# 在containers下对齐name，添加ports,滚动更新
...
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80

# 为deployment front-end创建service，暴露容器80端口，类型为NodePort, yml文件中如果不指定nodePort端口则随机一个30000+端口
kubectl expose deployment front-end --port=80 --target-port=80 --protocol=TCP  --type=NodePort --name=front-end-svc --dry-run=client -o yaml > service.yml
kubectl apply -f service.yml 

# 验证,service的IP和端口
curl 10.96.229.108:80 
