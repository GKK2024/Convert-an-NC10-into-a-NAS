# i386-Docker及应用部署

## 安装docker、docker-compose

简介：Docker是一种轻量级的虚拟化技术，同时是一个开源的应用容器运行环境搭建平台，可以让开发者以便捷方式打包应用到一个可移植的容器中，然后安装至任何运行Linux或Windows等系统的服务器上。相较于传统虚拟机，Docker容器提供轻量化的虚拟化方式、安装便捷、启停速度快。详见：[官网](https://www.docker.com/)。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Docker Compose 是用于定义和运行多容器Docker 应用程序的工具。 在Compose 中，可以使用YAML 文件来配置应用程序的服务。 然后，运行一条命令，即可从配置中创建并启动所有服务。 使用Compose 可在一台主计算机上方便地协调多个容器映像。[Docker Compose | 文档](https://docs.docker.com/compose/)。

**使用Debian仓库安装主程序**

```
# 安装主程序
sudo apt install -y docker.io docker-compose
# 检验安装版本
docker --version
docker-compose version
```

**设置国内源加速**

单次拉取加速

> <URL> 填需要拉去的镜像地址

```
docker pull docker.1panel.dev/<URL>
```

默认自动加速

> 设置额守护进程代理

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

## i386-镜像部署

> [!IMPORTANT]
>
> 1. 当需要拉去特定架构的镜像时，在拉去命令后加"@<Index digest>"，"<Index digest>"的值从docker hub网站获取。
> 2. 所有命令在root管理员身份下执行，或者使用sudo命令执行。

### LANraragi

Docker Hub：[LRR 原版](https://hub.docker.com/r/difegue/lanraragi) | [LRR 汉化版](https://hub.docker.com/r/windycloud/lanraragi_cn/tags) 

拉取镜像

```
# 原版
docker pull difegue/lanraragi:nightly@sha256:40b6c969f60f0250e0360a5bd6491dd1817d31768c1f23c183ef1ba72a17d8de
# 汉化版
docker pull windycloud/lanraragi_cn:dev@sha256:c08e766d29305bd00e00e4a20f7ddb315adef2f173c223c10edb2c417d1b4c0f
```

创建程序安装目录

```
mkdir -p /home/test/software_home/lanraragi/content/thumb \
-p /home/test/software_home/lanraragi/database
```

启动程序

> 根据需求修改"source="路径信息;
>
> 启动汉化版替换最后一行"difegue/lanraragi"的内容；

```
docker run -d \
--name=lanraragi \
-p 3000:3000 \
--mount type=bind,source=/home/test/software_home/lanraragi/content,target=/home/koyomi/lanraragi/content \
--mount type=bind,source=/home/test/software_home/lanraragi/database,target=/home/koyomi/lanraragi/database \
--mount type=bind,source=/home/test/software_home/lanraragi/content/thumb,target=/home/koyomi/lanraragi/content/thumb \
difegue/lanraragi:nightly@sha256:40b6c969f60f0250e0360a5bd6491dd1817d31768c1f23c183ef1ba72a17d8de
```

网页访问

> 默认端口：3000

```
http://<ip>:port
例：http://192.168.1.54:3000
```

帮助文档：[使用手册 · LRR](https://sugoi.gitbook.io/lanraragi/installing-lanraragi/source) | [原版GitHub](https://github.com/Difegue/LANraragi  ) | [中文版GitHub](https://github.com/uparrows/LANraragi_cn) 

### Home Assistant

Docker Hub：[i386-homeassistant](https://hub.docker.com/r/homeassistant/i386-homeassistant/tags)

拉取镜像

```
docker pull homeassistant/i386-homeassistant
```

创建 Home Assistant 配置目录

```
mkdir -p /root/.homeassistant
```

启动程序

> 按需真实路径修改配置文件目录的位置，示例："/root/.homeassistant"

```
docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=MY_TIME_ZONE \
  -v /root/.homeassistant:/config \
  -v /run/dbus:/run/dbus:ro \
  --network=host \
  homeassistant/i386-homeassistant
```

网页访问

> 默认端口：8123

```
http://<ip>:port
例：http://192.168.1.54:8123
```

帮助文档：[Home Assistant · 官网](https://www.home-assistant.io/installation/linux#install-home-assistant-core) 