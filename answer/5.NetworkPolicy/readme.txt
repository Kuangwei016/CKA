# 在K8S文档中查找network policy模板
# 复制并修改
# vim network-policy.yml

#### 修改一  争议点
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: internal
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          ns: internal    # 通常namespace是没有标签的，上面metadata中已经有namespace了，ingress from中是否还需要namespaceSelector来规定范围，如果要则需要给namespace打一个标签
    ports:
    - protocol: TCP
      port: 9000

#### 修改二
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: internal
spec:
  podSelector:
    matchLabels: {}
  ingress:
  - from:
    - podSelector:
        matchLabels: {}
    ports:
    - protocol: TCP
      port: 9000

# 采用修改一，(考试环境不需要自行创建)创建namespace internal,并给它标签ns: internal
kubectl create namespace internal
kubectl get namespace internal --show-labels
kubectl label namespace internal ns=internal   

# 创建network policy
kubectl apply -f network-policy.yml
