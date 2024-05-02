# 没有公网 IPv4 也能玩转 Homelab 远程访问

家用 Homelab 远程访问的场景大多有三个：

1. 共享内部服务到外网访问 (比如 RSSHub)；
2. 外部设备连接家庭内网，访问内网的各种服务/设备；
3. PT 连通性和上传速度。

常用的方案有 FRP 代理、IPv6、Zerotier 等，但都有各自的缺点：

1. FRP 非直连，依赖代理服务器带宽，不一定跑慢带宽；
2. IPv6 要求外部设备的网络也支持 IPv6，好多办公网络是不支持的；
3. Zerotier 有时间不能直连，需要中转速度很慢；
4. **都无法解决 PT 上传**的问题。

**我现在折腾的方案用了大概两年，稳定性很好，几乎可以媲美公网 IPv4。**

但是也有一些前置条件：

1. 宽带 NAT 为 NAT1(Full Cone)；
2. 路由拨号，路由器系统最好是 Openwrt (其他 Linux 发行版也行，但无法抄作业)。
3. 有一个内网设备支持运行 Clash (运行在主路由也行)。

也有一些好处：

1. 不需要代理服务器，可以跑满带宽。
2. 不依赖 IPv6，有 IPv6 更好一些。
3. 支持 PT 上传。

**如果你的网络和设备满足上面的条件，就可以按照我的方案来尝试了。**

此仓库的代码是用来部署到 Vercel 服务端的, 相关教程见：<https://chi.miantiao.me/posts/without-ipv4/>

## 部署教程

1. 通过下面按钮一键部署此下面到 Vercel

[![Vercel](https://vercel.com/button)](https://vercel.com/new/miantiao/clone?repository-url=https%3A%2F%2Fgithub.com%2Fccbikai%2Fwithout-ipv4)

2. 创建 KV Database 存储，并且关联到此项目

![image](https://github.com/ccbikai/without-ipv4/assets/2959393/41d52fa9-0e90-4572-a45d-5893bab68bf1)

3. 再 Deployments 中重写部署一次

![image](https://github.com/ccbikai/without-ipv4/assets/2959393/35e617fe-ac06-4e82-8aab-f5a583a3f134)
