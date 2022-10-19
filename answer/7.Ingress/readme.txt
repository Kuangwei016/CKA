# 为测试创建deployment和service
kubectl create deployment nginx-hi -n ing-internal --image=nginx --dry-run=client -o yaml  > deployment.yml
kubectl apply -f deployment.yml 

kubectl expose deployment nginx-hi -n ing-internal --port=5678 --target-port=80 --protocol=TCP --name=hi --dry-run=client -o yaml > service.yml
kubectl apply -f service.yml


# 用ingress将service端口暴露出来, kubectl create ingress命令创建的模板修改的地方比较多，直接用文档中的模板再修改
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: pong
  namespace: ing-internal      # 模板中没有指定namespace
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:                      
      paths:
      - path: /hi
        pathType: Prefix       # 如果用create创建的话，这里的类型不是prefix
        backend:
          service:
            name: hi
            port:
              number: 5678

# 前提是已经安装了ingress-control
# 验证, 这里的IP是Node or master, 访问/hi跳转到service的5678端口,即pod的80端口
curl -kL 192.168.1.11/hi
