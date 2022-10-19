# 先查看node的状态是否都是ready

# 再通过describe, 查看有没有noSchedule
kubectl describe node|grep -i "Taints"
Taints:             node-role.kubernetes.io/master:NoSchedule
Taints:             <none>
Taints:             <none>

# 将结果写入指定文件
echo 2 > /opt/KUSC00402/kusc00402.txt
