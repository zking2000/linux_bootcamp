# IPTABLES

```
# Allow SSH
iptables -A INPUT -s 10.20.30.40/24 -p tcp --dport 22 -j ACCEPT

# Drop from 10.10.10.10
iptables -A INPUT -s 10.10.10.10 -j DROP

# Drop port 1234 from local
iptables -A OUTPUT -p tcp --dport 123 -j DROP

# Port redirect (80 - 8080)
iptables -t nat -a PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080

# Disable ICMP
iptables -A INPUT -p icmp -j DROP

# Clear all
iptables -F

# Clear table
iptables -t nat -F

# Delete a rule
iptables -D INPUT -s 10.10.10.10 -j DROP

# Delete an customized chain
iptables -X FOO

# Customize chain
iptables -t nat -H BAR

# DNAT
根据指定条件修改数据包的目标IP地址和目标端口
iptables -t nat -A PREROUTING -d 1.2.3.4 -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.20.30.40:8080

#SNAT
根据条件修改数据包的源IP地址，也就是将Pod内部的IP:PORT替换为宿主机的IP:PORT 即DNAT的逆操作

iptables -t nat -A POSTROUTING -o eth0 -s 192.168.1.2 -j SNAT --to-source 10.172.16.1

# save rule

iptables-save
iptables-save > iptables.bak

# Restore
iptables-restore < iptables.bak
```

```
Linux原生支持5中L3隧道：
ipip：IPV4 in IPV4 在IPV4报文的基础上封装一个IPV4报文
GRE：通用路由封装，定义了在任意一种网络层协议上封装其他任意一种网络层协议的机制
SIT：用IPV4报文封装IPV6报文
ISATAP：站内自动隧道寻址协议 Intra-Site Automatic Tunnel Addressing Protocol 用于IPV6的隧道封装
VTI：虚拟隧道接口

Linux L3隧道底层实现原理都基于tun设备

# 打开Linux路由功能
echo 1 > /proc/sys/net/ipv4/ip_forward
或
net.ipv4.ip_forward = 1 > /etc/sysctl.conf
```

```
# VXLAN
# Macvlan
# IPvlan
```

# DOCKER
```
# Docker的网络模式
bridge ： 单独的network namespace
host：与主机共享network namespace
container：共享其他容器的network namespace
none 

docker port 35e50d6903e2 80
0.0.0.0:2345

docker network create -d bridge --subnet 192.168.32.0/19 44084750

目前主流两种的网络接口方案，Docker主导的Container Network Model (CNM) | Kubernetes的CNI

CNM：
Network Sandbox: 容器网络栈。包括网卡、路由表、DNS配置等
Endpoint：Sandbox接入Network的介质，是Network Sandbox和Backend Network的中间桥梁。对应技术有veth pair、TAP/TUN、OVS
Backend Network：一组可以直接相互通信的endpoint集合。对应技术实现有Linux beidge | vlan等
NetworkController： 对外提供分配及管理网络的APIs
Driver：负责一个Network的管理，包括资源分配和回收

隧道网络也称为overlay网络，在传统网络上虚拟出一个虚拟网络，承载的底层网络不再需要做任何适配。
基于overlay的网络插件：
Weave
openvswitch
Flannel

通过路由来实现：
Calico: 一个纯三层网络方案
- 不同主机上的每个容器内部都配一个路由，指向自己所在的IP地址。每台服务器编程路由器，配置自己的路由规则，通过网卡直接到达目标容器，整个过程没有封包
Macvlan
Metaswitch
```

# KUBERNETES
```
kube-proxy：每个计算节点都运行一个kube-proxy进程，通过复杂的iptables/IPVS规则在pod和service之间进行各种过滤和NAT

CNI：
主要负责容器的网络设备初始化工作。
创建容器内的eth0

kubernetes容器的默认组网方案是bridge.跨主机方案通过第三方插件完成，例如calico

PAUSE容器：第一个被创建。里面运行着一个功能十分简单的C程序，具体逻辑是已启动就把自己永远在阻塞在哪里。作用就是占用一个linux的network namespace。扮演PID为1的进程，init进程，也就是所有进程的父进程。

容器使用PID namespace对PID进行隔离，因此每个容器中均有独立的init进程。所以docker stop也就是终止容器内的init进程。一旦init进程被销毁，同一PID namespace下的进程也随之被销毁

# 使用PID namespace 共享/隔离


```