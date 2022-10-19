# 已知node02 状态为NotReady

# 登陆node02，并切换至root
ssh node02
sudo -i

# 检查kubelet状态
systemctl status kubelet

# 启动kubelet并设置开机自启
systemctl start kubelet
systemctl enable kubelet
