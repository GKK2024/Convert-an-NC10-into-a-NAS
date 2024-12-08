# Docker(i386)应用部署

前言：因为32位系统已经不是主流，大部分的应用程序也渐渐放弃适配，docker也是如此，所以已经不能按照官网的方法安装最新的docker，而目前能够使用的只有Ubuntu仓库还在维护的"docker.io"，后文记录的是折腾过程中使用过并且能够成功安装运行的方法。我的建议是能够使用二进制程序坚决不使用docker，因为运行过程中有可能崩溃致使所有容器甚至docker本身都无法启动，还有一点是docker镜像比直接使用二进制文件更占空间，启动盘空间小的会影响系统运行。

## 安装docker、docker-compose

简介：Docker是一种轻量级的虚拟化技术，同时是一个开源的应用容器运行环境搭建平台，可以让开发者以便捷方式打包应用到一个可移植的容器中，然后安装至任何运行Linux或Windows等系统的服务器上。相较于传统虚拟机，Docker容器提供轻量化的虚拟化方式、安装便捷、启停速度快。详见：[官网](https://www.docker.com/)。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Docker Compose 是用于定义和运行多容器Docker 应用程序的工具。 在Compose 中，可以使用YAML 文件来配置应用程序的服务。 然后，运行一条命令，即可从配置中创建并启动所有服务。 使用Compose 可在一台主计算机上方便地协调多个容器映像。[Docker Compose | 文档](https://docs.docker.com/compose/)。

### **使用Debian仓库安装主程序**

1、安装主程序

```
sudo apt install -y docker.io docker-compose
```

2、检验安装版本

```
sudo docker --version
sudo docker-compose --version
```

### **设置国内源加速**

1、单次拉取加速

> "<URL> "填需要拉取的镜像仓库地址

```
docker pull docker.1panel.dev/<URL>
```

2、默认自动加速

> 设置额守护进程代理；有效代理地址可以从"小雅alist周边"的脚本获取；

```
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.1panel.live",
    "https://freeno.xyz",
    "https://docker.luyao.dynv6.net",
    "https://dockerhub.anzu.vip",
    "https://docker.jsdelivr.fyi",
    "https://hub.uuuadc.top",
    "https://hdocker.chenby.cn"
  ]
}
EOF
```

> 重载配置

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

帮助文档：[手册 | Docker Docs](https://docs.docker.com/manuals/) | 

## 部署镜像及容器(i386)

> [!IMPORTANT]
>
> 1. 当需要拉去特定的某个镜像时，可以在命令后面上“@sha256:id”，"sha256:id"的值从docker hub网站的具体镜像的"Manifest digest"处获取。
> 2. 注意：所有命令均在root管理员身份下执行，或者使用sudo命令执行。

### LANraragi

> Docker Hub：[LRR 原版](https://hub.docker.com/r/difegue/lanraragi) | [LRR 汉化版](https://hub.docker.com/r/windycloud/lanraragi_cn/tags) 

1、创建程序安装目录

```
mkdir -p /opt/lanraragi/content/thumb /opt/lanraragi/database
```

2、创建并启动容器

> 根据需求修改"source="路径信息；
>

```
sudo docker run -d \
--name=lanraragi \
-p 3000:3000 \
--mount type=bind,source=/opt/lanraragi/content,target=/home/koyomi/lanraragi/content \
--mount type=bind,source=/opt/lanraragi/database,target=/home/koyomi/lanraragi/database \
--mount type=bind,source=/opt/lanraragi/content/thumb,target=/home/koyomi/lanraragi/content/thumb \
windycloud/lanraragi_cn:dev
```

3、管理地址：http://yourhostIP:3000

帮助文档：[使用手册 · LRR](https://sugoi.gitbook.io/lanraragi/installing-lanraragi/source) | [原版GitHub](https://github.com/Difegue/LANraragi  ) | [中文版GitHub](https://github.com/uparrows/LANraragi_cn) 

### Home Assistant

> Docker Hub：[homeassistant (i386合集)](https://hub.docker.com/r/homeassistant/i386-homeassistant/tags)  | [homeassistant/home-assistant·官网](https://hub.docker.com/r/homeassistant/home-assistant/tags) 

1、启动程序

> 按需真实路径修改配置文件目录的位置，示例："/root/.homeassistant"；

```
sudo docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=MY_TIME_ZONE \
  -v /root/.homeassistant:/config \
  -v /run/dbus:/run/dbus:ro \
  --network=host \
  homeassistant/home-assistant:2024.3.3
```

2、管理地址：http://yourhostIP:8123

帮助文档：[Home Assistant · 官网](https://www.home-assistant.io/installation/linux#install-home-assistant-core) 

### quark-auto-save

简介：夸克网盘签到、自动转存、命名整理、发推送提醒和刷新媒体库一条龙。定期执行本脚本自动转存、文件名整理，配合 Alist, rclone, Emby 可达到自动追更的效果。

> 原作者项目：[Cp0204·Github](https://github.com/Cp0204/quark-auto-save) | Docker Hub：[cp0204/quark-auto-save](https://hub.docker.com/r/cp0204/quark-auto-save) 
>
> i386专版·Docker Hub：[gkk2024/quark-auto-save](https://hub.docker.com/r/gkk2024/quark-auto-save) 

**使用方法：**docker-compose

1、创建一个"docker-compose.yml"文件，并填入下方内容。

```
cd ~
nano docker-compose.yml
```

```
version: '3'

services:
  quark-auto-save:
    image: gkk2024/quark-auto-save:default  # "default"默认为第一版：v0.3.9；可替换为具体tag版本号；
    container_name: quark-auto-save
    network_mode: bridge
    ports:
      - 5005:5005
    restart: unless-stopped
    environment:
      # 可修改账号密码
      WEBUI_USERNAME: "admin"
      WEBUI_PASSWORD: "admin123"
    volumes:
      # "/opt"可修改为其他路径
      - /opt/quark-auto-save/config:/app/config
      - /opt/quark-auto-save/media:/media
```

2、创建并启动程序：

```
sudo docker-compose up -d
```

3、管理地址：http://yourhost:5005

> 默认账号：admin 
>
> 默认密码：admin123⁠⁠

### Adguard Home

> Docker Hub：[adguardhome (官版)](https://hubgw.docker.com/r/adguard/adguardhome/tags) | [adguardhome (配置加强版)](https://hubgw.docker.com/r/adam9999/adguardhome) 



### Aria2 Pro

> Docker Hub：[p3terx/aria2-pro](https://hub.docker.com/r/p3terx/aria2-pro) | [ddsderek/aria2-pro 可屏蔽迅雷](https://hub.docker.com/r/ddsderek/aria2-pro) | [tingv/aria2-pro 增加TG通知](https://hub.docker.com/r/tingv/aria2-pro) 

部署"p3terx/aria2-pro"：

&nbsp;&nbsp;&nbsp;&nbsp;设置下方的"<TOKEN>"为具体数值，如 1234，此后将用作aria2的密钥；"$PWD"会自动获取执行命令时的路径来创建配置文件和下载目录，也可以修改位具体路径，如 "/opt/aria2-pro"。

> 命令行执行下方命令

```
sudo docker run -d \
    --name aria2-pro \
    --restart unless-stopped \
    --log-opt max-size=1m \
    -e PUID=$UID \
    -e PGID=$GID \
    -e UMASK_SET=022 \
    -e RPC_SECRET=<TOKEN> \
    -e RPC_PORT=6800 \
    -p 6800:6800 \
    -e LISTEN_PORT=6888 \
    -p 6888:6888 \
    -p 6888:6888/udp \
    -v $PWD/aria2-config:/config \
    -v $PWD/aria2-downloads:/downloads \
    p3terx/aria2-pro
```

### AriaNG

> Docker Hub：[p3terx/ariang](https://hub.docker.com/r/p3terx/ariang) | [kimi360/ariang](https://hub.docker.com/r/kimi360/ariang) 

1、在线版本：[AriaNg](https://ariang.mayswind.net/latest/#!/downloading) 

2、部署：p3terx/ariang

> 命令行执行下方命令

```
sudo docker run -d \
    --name ariang \
    --log-opt max-size=1m \
    --restart unless-stopped \
    -p 6880:6880 \
    p3terx/ariang
```

> 访问地址：http://youhostIP:6880

### qbittorrent

> Docker Hub：[snowdreamtech/qbittorrent](https://hubgw.docker.com/r/snowdreamtech/qbittorrent) | [qbittorrentofficial/qbittorrent-nox](https://hubgw.docker.com/r/qbittorrentofficial/qbittorrent-nox) | [nevinee/qbittorrent·自动分类版](https://hubgw.docker.com/r/nevinee/qbittorrent) 

> [!CAUTION]
>
> WebUI总是提示账号密码错误，暂时没找到解决办法。

1、部署“snowdreamtech/qbittorrent”

2、管理地址：http://youhostIP:8080

> 默认账户/密码：admin

### qBittorrent-ClientBlocker

> Docker Hub：[qbittorrent-clientblocker](https://hubgw.docker.com/r/simpletracker/qbittorrent-clientblocker) 



### transmission

> Docker Hub：[gists/transmission](https://hubgw.docker.com/r/gists/transmission) | [jaymoulin/transmission](https://hubgw.docker.com/r/jaymoulin/transmission) 

1、部署方法：命令行执行

```
sudo docker run \
    -d \
    --name transmission \
    -p 9091:9091 \
    -p 51413:51413 \
    -v /opt/transmission:/data \
    -e USERNAME=transmission \
    -e PASSWORD=transmission \
    gists/transmission:latest
```

2、管理地址：http://youhostIP:9091

> 默认账号/密码：transmission / transmission

### Alist

> Docker Hub：[alist 美化版](https://hub.docker.com/r/leolitaly/sweet-cloud) | [alist 消息版](https://hub.docker.com/r/ykxvk8yl5l/alist) | [alist 内置aria2](https://hub.docker.com/r/xhofe/alist-aria2) | [alist 官方版](https://hub.docker.com/r/xhofe/alist) 

1、部署"alist 官方版"

> 命令行执行下方代码

```
sudo docker run -d \
    --restart=always \
    -v /opt/alist:/opt/alist/data \
    -p 5244:5244 \
    -e PUID=0 \
    -e PGID=0 \
    -e UMASK=022 \
    --name="alist" \
    xhofe/alist:latest-ffmpeg
```

2、管理地址：http://youhostIP:5244

> 默认管理员账号：admin
>
> 首次启动alist查看日志的默认密码："<CONTAINER ID>"改为具体ID值
>
> ```
> # 查询容器ID
> sudo docker ps
> # 查看容器日志
> sudo docker logs <CONTAINER ID>
> ```
>
> 设置新密码："NEW_PASSWORD"改为新的密码。
>
> ```
> sudo docker exec -it alist ./alist admin set "NEW_PASSWORD"
> ```

