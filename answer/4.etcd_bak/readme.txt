# 首先通过kubectl describe获取到etcd证书与data目录
kubectl describe pods  etcd-master01 -n kube-system
    Mounts:
      /etc/kubernetes/pki/etcd from etcd-certs (rw)
      /var/lib/etcd from etcd-data (rw)
--data-dir=/var/lib/etcd
--advertise-client-urls=https://192.168.1.11:2379
--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
--cert-file=/etc/kubernetes/pki/etcd/server.crt
--key-file=/etc/kubernetes/pki/etcd/server.key

# 以上信息对应etcdctl参数需要修改,通过-h查看参数
--trusted-ca-file  对应 etcdctl --cacert
--key-file  对应 etcdctl --key
--cert-file 对应 etcdctl --cert
--advertise-client-urls 对应 etcdctl --endpoints

# 备份
ETCDCTL_API=3  etcdctl --endpoints="https://192.168.1.11:2379" --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key  snapshot save /root/k8s/CKA/4.etcd_bak/etcd-snapshot.db

# 需要--data-dir参数指定数据目录，否则默认defalut.etcd，在宿主机上将原数据目录备份
mv /var/lib/etcd  /var/lib/etcd_bak
# 还原
ETCDCTL_API=3  etcdctl --endpoints="https://192.168.1.11:2379" --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key  --data-dir /var/lib/etcd snapshot restore /root/k8s/CKA/4.etcd_bak/etcd-snapshot.db

# 验证,能get到数据则成功
etcdctl  --endpoints="https://192.168.1.11:2379" --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --prefix --keys-only=true get /
