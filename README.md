# 旧物利用——三星上网本（NP-NC10）改做NAS使用
  将2009年的三星上网本改做轻度NAS使用，实现存储、同步、观影、笔记等功能。基于32位CPU - Intel Atom N270 ，结合Debian12 和 OpenMediaVault 7争取最大程度实用和易用性。

  在此要**声明**一点，我这台笔记本是别人赠送的，我不鼓励你购买这台以及同类32位CPU的远古电子垃圾，它的性能和软件的适配是远远落后于当下的设备，功耗又高的很，哪怕是30~60块的机顶盒刷armbian后的功耗和易用性都是可以吊打它的存在。若很幸运你手上刚好有一台，哪也不放当做学习linux的工具，尝试玩一玩。

  由于N270是i686结构，导致其可以使用的程序非常有限，找寻和安装就显得困难一些，就连时下流行的docker，适用的容器也很少。而我建立文档的目的，首先是记录折腾的过程、遇到的问题和解决方法，其次是出于学习和交流，最后是将我收集的可用软件分享给给手上有同类型笔记本的朋友参考，折腾时少走一些弯路，避免重头从头摸索。

# 目录
## 笔记本硬件的介绍
## 底层系统的选择、安装及设置
  - 双系统系统与U盘启动
  - Debian12 安装与注意事项 
  - 安装后的必要设置
  - 启动菜单美化
## NAS系统OMV7的安装及设置
  - OMV系统及第三方插件的安装
  - 安装后的必要设置
## 系统工具及环境部署
  > 语言环境：Python Rust PHP Golang Java
  >   
  > 数据库：MariaDB MySQL SQLite3
  >
## 常用软件的安装
  >
  > 资源监控：btop glances
  > 
  > 下载：Aria2 qbittorrent transmission
  > 
  > 云盘：Alist Filebrowser 可道云
  > 
  > 阅读：calibre calibre-web Ubooquity Suwayomi_Server  阅读3（服务器版）
  > 
  > 音乐：Navidrome
  > 
  > 视频：Plex
  > 
  > 图片：PicHome EasyImages2.0 Piwigo
  > 
  > 同步：syncthing verysync
  > 
  > 内网穿透：Tailscale Zerotier
  > 
  > 代理：TPclash
  > 
  > DNS服务器：Adgruadhome SmartDNS
  > 
  > 笔记：Dokuwiki memos
  > 
  > 博客：Typecho
  > 
  > 导航页：home van-nav lylme
  >
## Docker及可用容器部署
- 安装docker、docker-compose
- docker可用软件镜像：
  > LANraragi ;
  > Aria2 Pro ;AriaNG ;
  > Alist ;
  >
