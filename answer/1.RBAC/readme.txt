# 创建一个名为deployment-clusterrole的clusterrole,并且对该clusterrole只绑定对Deployment，Daemonset,Statefulset的创建权限
# 在指定namespace app-team1创建一个名为cicd-token的serviceaccount，并且将上一步创建clusterrole和该serviceaccount绑定
# 原文链接：https://blog.csdn.net/qq_43891456/article/details/109327624

# 创建命名空间app-team1 
kubectl create ns app-team1

# 创建serviceaccount cicd-token 在app-team1中
kubectl create serviceaccount cicd-token -n app-team1 --dry-run=client -o yaml > ServiceAccount.yml
kubectl apply -f ServiceAccount.yml

# 创建clusterrole  deployment-clusterrole, 允许创建Deployment,Daemonset,Statefulset权限
kubectl create clusterrole  deployment-clusterrole  --verb=create --resource=Deployment,Daemonset,Statefulset --dry-run=client -o yaml > deployment-clusterrole.yml
kubectl apply -f deployment-clusterrole.yml

# 将clusterrole: deployment-clusterrole 与 serviceaccount: cicd-token 绑定 
kubectl create rolebinding deployment-rolebinding -n app-team1 --clusterrole=deployment-clusterrole --serviceaccount=app-team1:cicd-token --dry-run=client -o yaml > deployment-rolebinding.yml 
kubectl apply  -f deployment-rolebinding.yml

# 测试使用cicd-token 创建deployment， 返回yes则通过
kubectl auth can-i create deployment -n app-team1 --as=system:serviceaccount:app-team1:cicd-token
