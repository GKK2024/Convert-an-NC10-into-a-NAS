# 旧物利用——三星上网本（NP-NC10）改做NAS使用
前言：

&emsp;&emsp;将2009年的三星上网本改做轻度NAS使用，实现存储、同步、观影、笔记等功能。基于32位CPU - Intel Atom N270 ，结合Debian12 和 OpenMediaVault 7争取最大程度实用和易用性。

&emsp;&emsp;在此要**声明**一点，我这台笔记本是别人赠送的，我不鼓励你购买这台以及同类32位CPU的远古电子垃圾，它的性能和软件的适配是远远落后于当下的设备，功耗又高的很，哪怕是30~60块的机顶盒刷armbian后的功耗和易用性都是可以吊打它的存在。若很幸运你手上刚好有一台，哪也不妨当做学习linux的工具，尝试玩一玩。

&emsp;&emsp;由于N270的i686结构以及年代久远的关系，导致其网上有关的系统和程序安装资料比较有限，找寻可用的程序就显得相对困难一些，就连时下流行的docker，适用的容器也很少。于是，我建立了此文档，首先是系统的整理、记录折腾的过程、遇到的问题和解决方法，其次是出于学习和交流，发扬互联网分享精神，最后是将我收集的可用软件信息分享给手上有同类型笔记本的朋友参考，以便后来人折腾时少走一些弯路，避免重头从头摸索。

![](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408100012009.jpg)
## 目录
### 笔记本硬件的介绍
### 底层系统的选择、安装及设置
> Debian12 系统的安装
>
> Debian 系统初始化设置

### NAS系统OMV7的安装及设置
> OMV 7 一键安装脚本
>
> OMV 7 初始化设置

### 开发语言及数据库部署
  > 开发语言：Python | Rust | PHP | Golang | Java
  >   
  > 数据库：MariaDB | MySQL | SQLite3
  >
### 常用软件的安装
  >
  > 资源监控：btop | glances
  > 
  > 下载：Aria2 | qbittorrent | transmission
  > 
  > 云盘：Alist | Filebrowser | 可道云
  > 
  > 阅读：calibre | calibre-web | Ubooquity | Suwayomi_Server | 阅读3(服务器版)
  > 
  > 音乐：Navidrome
  > 
  > 视频：Plex
  > 
  > 图片：PicHome | EasyImages2.0 | Piwigo
  > 
  > 同步：syncthing | verysync
  > 
  > 内网穿透：Tailscale | Zerotier
  > 
  > 代理：TPclash
  > 
  > DNS服务器：Adgruadhome | SmartDNS
  > 
  > 笔记：Dokuwiki memos
  > 
  > 博客：Typecho
  > 
  > 导航页：home | van-nav | Lylme
  >
### Docker及可用容器部署
> 安装docker、docker-compose
>
> docker可用软件镜像：
>
> > LANraragi ;
> >
> > Aria2 Pro ; AriaNG ;
> >
> > Alist ;

### 番外篇

> batocera-5.25-x86
>
> openwrt-x86
>
> ikuai_x32
>
> NanoBoot-x86-5.0.3.1



### 导航页的应用展示

![image-20240810150016814](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408101500010.png)

![image-20240810150309630](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408101503848.png)

