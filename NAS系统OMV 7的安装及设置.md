# NAS系统OMV-7的安装及设置

&emsp;选择OMV-7作为nas系统的原因前面已经说过了，后面将会介绍如何在三星NC10上安装它。这里将采用脚本的安装方法，这也是官方推荐的安装方法，原因则是最新的OMV系统镜像已经不支持直接在i386&i686的CPU上安装它了。

&emsp;这里必须再次强调，Debian系统不能提前安装桌面环境和web服务器，否则OMV安装会报错失败。如果你已经安装过，要么手动卸载掉，要么重新安装最精简的Debian系统。目前比较推荐的OMV又6和7两个版本，分别对应Debian的11和12。我选择了最新的OMV7，因为有着更长的更新周期。

## OMV-7一键安装脚本

&emsp;OMV7的安装脚本是来源于github，国内有些地区可能访问不了，免不了就需要使用代理才能够成功安装。这里默认有科学上网的方法，如果你没有，请往后面看其他不需要使用代理的方法。

### 设置代理加速：

> 首先，在电脑上使用clash/clash Verge等类似软件，开启局域网连接或局共享访问，获取代理IP地址和端口。手机上使用surfboard设置也可以达到相同效果。
>
> 然后，给Deepin设置临时代理，加速GitHub访问
>
> 最后，复制 curl google.com.hk 到putty窗口运行，查看能否访问成功。

> 临时代理设置方法：将下方命令补充完整，依次粘贴到putty窗口中运行

```
export http_proxy="http://IP:Port"		# IP	局域网共享的ip
export https_proxy="http://IP:Port"		# port  共享端口
```

### 一键安装OMV本体:

> 请提前安装wget工具，没有安装请看文档的Debian系统初始化设置这部分

> 在前面代理设置的基础后，完整复制下方命令，粘贴到putty的窗口中运行。
>
> > Tips：安装过程中，不可终断或关闭终端窗口；若遇到权限问题，可切换到root用户在执行上方命令。

```
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install | sudo bash
```

> 脚本执行完，检验安装。浏览器输入NC10的IP地址，尝试访问WebUI
>
> 演示机ip：192.168.1.54
>
> 显示如下界面表示安装成功

![image-20240812215408472](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408122154809.png)

参考文档：

["installScript"脚本作者的仓库 - GitHub](https://github.com/OpenMediaVault-Plugin-Developers/installScript/tree/master)

[Openmediavault 7 的文档和参考资料](https://wiki.omv-extras.org/doku.php?id=omv7:omv7)  |  [openmediavault 7.x.y 官方文档](https://docs.openmediavault.org/en/latest/installation/index.html)

[openmediavault-docs—OMV各版本安装文档 - github](https://github.com/openmediavault/openmediavault-docs/blob/7.x/installation/index.rst)

### 安装OMV-Extras - 第三方插件库

> 安装本体后，需要重启一下系统

```
sudo reboot
```

> 重启后，普通用户权限被限制，无法通过putty登录ssh
>
> 故，以root管理员身份登录，并重新设置临时代理

```
export http_proxy="http://IP:Port"
export https_proxy="http://IP:Port"
```

> 将下方命令完整复制并粘贴到putty的窗口运行：
>
> > Tips：在脚本完成之前，不要关闭终端窗口。

```
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/install | bash
```

> 脚本执行完，检验安装：
>
> > 浏览器输入NC10的IP地址并登录；
> >
> > 默认用户名：admin ； 默认密码：openmediavault
>
> 进入在 OMV7  WebUI后，依次点击“系统”---->“插件”，单击“放大镜”图标可以检查更新，然后滑动到最下方，可以看到插件总数50个，表示安装成功了。
>
> 。。。第一次安装的时候，只有46个，插件又增加了ヽ(￣▽￣)ﾉ。。。

![image-20240812230845164](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408122308374.png) 

参考文档：[作者的"packages"仓库 - GitHub](https://github.com/OpenMediaVault-Plugin-Developers/packages) |  [OMV-7-Extras 官方安装手册]([misc_docs：omv_extras [omv-extras.org\]](https://wiki.omv-extras.org/doku.php?id=misc_docs:omv_extras))

### 无代理安装OMV-7及插件库

&emsp;如果你没有代理，无法通过github原仓库中安装OMV，那你可以尝试我fork到gitee上导入的仓库，虽无法时刻保证最新，但安装成功后可以直接获得官方支持，在线更新一次就好。

#### 安装OMV-7 本体

1. 克隆仓库到本地

   ```
   git clone https://gitee.com/GKK2024/install-script.git
   ```

2. 执行安装脚本

   ```
   sudo ./install-script/install
   ```

3. 按“一键安装OMV-7脚本”的方法检验安装。

#### 手动安装插件库（一）：

&emsp;本体安装后，暂时不能直接使用插件，点击会有500报错，这是因为插件展示还没有软件源。与有代理安装方法不同的是，这里无需重启NC10，可以直接下载并安装第三方库的插件包，“all7”中包含了所有架构的三方库。

1. 下载deb包：openmediavault-omvextrasorg_latest_all7.deb	{ [Github](https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/packages/master/openmediavault-omvextrasorg_latest_all7.deb)  |  [Gitee](https://gitee.com/GKK2024/packages/blob/master/openmediavault-omvextrasorg_latest_all7.deb) }

   ```
   wget https://gitee.com/GKK2024/packages/blob/master/openmediavault-omvextrasorg_latest_all7.deb
   ```

2. 使用dpkg命令安装

   ```
   sudo dpkg -i openmediavault-omvextrasorg_latest_all7.deb
   ```

3. 按照前文“第三方插件库”的方法进行检验安装。

#### 手动安装插件库（二）：

&emsp;由于我fork了原作者的仓库，这里提供一个通过CND加速连接安装插件库的方法，只需要将命令完整复制并粘贴到putty窗口执行即可，安装后的效果与上面的方法效果相同，二者选择其一即可；末尾出现“Press ctrl-shift-R in the browser after signing in to the OMV web interface.”则表示安装成功，检验安装的方法同上。

```
 sudo wget -O - https://gitee.com/GKK2024/packages/raw/master/install | sudo bash
```

> 若出现“E: Could not get lock /var/cache/apt/archives/lock. It is held by process 410 (apt-get)”报错，重启系统时最简单的解决办法。

参考文档：

[个人NAS系统方案二(1/8) OMV6系统和扩展库安装](https://zhuanlan.zhihu.com/p/627905956)

[在树莓派上安装 OpenMediaVault（OMV） | 壹派胡言](https://www.yisihudong.com/2021/01/04/在树莓派上安装 OpenMediaVault（OMV）/#:~:text=运行 OMV 安装脚本 在终端运行下面的命令开始安装： wget,-O - https%3A%2F%2Fgithub.com%2FOpenMediaVault-Plugin-Developers%2FinstallScript%2Fraw%2Fmaster%2Finstall | sudo bash)

### 关于安装中报错信息的记录

&emsp;安装过程中不免会遇到一些报错，这对于新手、小白来说，无疑是会影响安装速度甚至停滞不前；起初由于不熟悉，也踩了许多坑，我为了避免重复造轮子，我将遇到的报错信息进行汇总记录，帮助自己快速查找解决方法。这些报错并非一定出现，如果是按照文档一步步进行配置，大概率不会遇到。

报错1：

> "raw.githubusercontent.com:443"

&emsp;443 端口连接被拒，一般是因为被墙，需要挂代理。

报错2：

> 升级了 0 个软件包，新安装了 0 个软件包，要卸载 0 个软件包，有 0 个软件包未被升级。
>
> --2024-08-12 22:26:32--  https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master//openmediavault-omvextrasorg_latest_all7.deb
>
> 正在解析主机 github.com (github.com)... 20.205.243.166
>
> 正在连接 github.com (github.com)|20.205.243.166|:443... 已连接。
>
> 已发出 HTTP 请求，正在等待回应... 302 Found
>
> 位置：https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/packages/master/openmediavault-omvextrasorg_latest_all7.deb [跟随至新的 URL]
>
> --2024-08-12 22:26:33--  https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/packages/master/openmediavault-omvextrasorg_latest_all7.deb
>
> 正在解析主机 raw.githubusercontent.com (raw.githubusercontent.com)... 0.0.0.0, ::
>
> 正在连接 raw.githubusercontent.com (raw.githubusercontent.com)|0.0.0.0|:443... 失败：拒绝连接。
>
> 正在连接 raw.githubusercontent.com (raw.githubusercontent.com)|::|:443... 失败：拒绝连接。
>
> There was a problem downloading the package.

&emsp;无代理则链接是被墙，通过挂载代理才能解决；有代理则是权限问题，切换root用户再执行依次命令，实测可以解决。无代理的另一种解决方法，使用dpkg手动安装下信息中的“openmediavault-omvextrasorg_latest_all7.deb”文件，使用dpkg命令进行安装。参考上方无代理安装方法。

报错3：

> "ERROR: The state 'flashmemory' does not exist"

&emsp;"flashmemory"插件安装失败，原因是i386&i686不支持脚本安装它。作用是优化TF卡/U盘读写，减少损耗的，不是非常重要，之后可以在插件中安装；若无此插件则需要重新运行插件安装脚本。

报错4：

> dpkg: warning: 'ldconfig' not found in PATH or not executable
>
> dpkg: warning: 'start-stop-daemon' not found in PATH or not executable
>
> dpkg: error: 2 expected programs not found in PATH or not executable
>
> Note: root's PATH should usually contain /usr/local/sbin, /usr/sbin and /sbin

&emsp;环境变量问题，root用户环境变量需要增加 /usr/local/sbin:/usr/sbin:/sbin  几个目录；root用户下临时添加PATH，只需要将下方内容粘贴到putty窗口中运行即可：

```
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
```

报错5：

> E: Could not get lock /var/cache/apt/archives/lock. It is held by process 410 (apt-get)
> N: Be aware that removing the lock file is not a solution and may break your system.
> E: Unable to lock directory /var/cache/apt/archives/
> Unable to install prerequisites.  Exiting.

&emsp;apt包管理程序被占用了，重启一下系统即可。一般出现在刚安装完OMV第三方插件库，"apt update"更新索引时。

### OMV-Extras插件 中文释义

> openmediavault-anacron	定时任务。特点：以天为单位执行；当关机时，任务会在下次开机时执行。
>
> openmediavault-apt		 apt管理插件，使用apt管理OMV插件。
>
> openmediavault-apttool	  apt 工具插件，可以再网页端查找、安装和删除软件包。
>
> openmediavault-autoshutdown	自动关机
>
> openmediavault-backup		 系统备份插件
>
> openmediavault-borgbackup	 borg备份插件
>
> openmediavault-clamav	 	 防病毒软件
>
> openmediavault-cputemp	       CPU温度检测插件
>
> openmediavault-diskclone	      再生龙备份插件
>
> openmediavault-diskstats		磁盘监控插件
>
> openmediavault-downloader	  下载器插件
>
> openmediavault-fail2ban		  防撞登录库保护插件，密码失败次数过多会自动拉黑ip地址
>
> openmediavault-flashmemory	 加载临时文件到内存插件，保护U盘/TF卡，较少写入消耗。
>
> openmediavault-forkeddaapd	 提供 daap 协议的音乐服务器，用于通过iTunes在本地网络上共享音乐
>
> openmediavault-ftp		FTP/SFTP/FTPS 服务器插件。
>
> openmediavault-hddfanctrl 7.0	用于在 Linux 上根据硬盘驱动器温度动态控制硬盘笼风扇速度。
>
> openmediavault-hosts	   用于在网页端修改host文件的插件
>
> openmediavault-iperf3	  内网测速工具iperf3
>
> openmediavault-k8s	       在轻量级 Kubernetes 环境中运行 Docker 容器
>
> openmediavault-kernel	 内核启动项管理插件，可以选择grub启动对象。
>
> openmediavault-kvm	     虚拟机插件
>
> openmediavault-locate	 搜索插件，网页端搜索系统软件包。
>
> openmediavault-luksencryption	磁盘加密插件
>
> openmediavault-lvm2	    LVM 管理。创建卷组和逻辑分区。
>
> openmediavault-md		创建、管理和监控基于 Linux MD（多设备）设备的软件 RAID。
>
> openmediavault-mergerfs      用于将多个文件夹“池化”在一个挂载点下，将不同的文件夹或存储设备聚合在一起，使得它们看起来像是一个单一的文件系统或存储卷。
>
> openmediavault-minidlna	 DLNA/UPnP-AV 服务器，在家庭网络中提供多媒体内容共享功能。
>
> openmediavault-mounteditor	用于编辑文件系统已挂载选项。
>
> openmediavault-nut 	UPS客户端/服务器监控系统，管理UPS电源。
>
> openmediavault-omvextrasorg	第三方插件库。
>
> openmediavault-podman		开源的容器管理工具
>
> openmediavault-remotemount	挂载远程存储/网盘的插件
>
> openmediavault-resetperms	重置共享文件夹的权限。 查看正在使用每个共享文件夹的插件。
>
> openmediavault-rsnapshot	开源的备份工具，可以增量备份。
>
> openmediavault-scripts		docker自定义脚本插件，用以维护和执行 docker-scripts。
>
> openmediavault-sftp		SFTP 服务器插件。
>
> openmediavault-shairport	AirPlay/RAOP 接收器插件，模拟 AirPort Express 以进行流式传输。
>
> openmediavault-sharerootfs	 共享根文件系统插件
>
> openmediavault-snapraid	磁盘阵列的备份程序
>
> openmediavault-snmp		简单网络管理协议(SNMP)插件
>
> openmediavault-symlinks	 符号链接插件
>
> openmediavault-tftp		TFTP 服务器，主要用于引导操作系统或获取配置文件
>
> openmediavault-tgt		用于设置 tgt iscsi 目标的插件。
>
> openmediavault-timeshift	系统快照插件， 通过采用增量 定期获取文件系统的快照，可以恢复以撤消对系统的所有更改。
>
> openmediavault-usbbackup	自动将共享文件夹同步到 USB/eSATA/SAS/SD 设备。
>
> openmediavault-wakealarm	自动开机
>
> openmediavault-webdav	      用于启用 WebDAV 并选择文件共享的 Web 界面。
>
> openmediavault-wireguard	 VPN远程组网工具
>
> openmediavault-wol		     局域网唤醒 
>
> openmediavault-zfs			ZFS文件系统插件

参考文档：[OMV-7官方手册——插件介绍](https://docs.openmediavault.org/en/latest/plugins.html)  |  [OMV6-7第三方插件介绍](https://wiki.omv-extras.org/)

## OMV-7初始化设置

### 用户账户设置

**增加ssh登录权限:**

&emsp;在安装了OMV本体后，我们设置的普通用户会被取消ssh登录权限，导致无法通过putty等终端连接工具登录服务器，所以需要在WebUI中恢复，将普通用户加入ssh组。

> 首先，在WebUI中展开"用户"栏，并进入用户设置界面；
>
> 接着，选中需要编辑的用户，点击上方的"编辑"按钮；
>
> 然后，找到"用户组"一行并展开选项菜单；
>
> 最后，在展开选项中勾选"_ssh"并保存设置。

![image-20240821173531421](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408211735720.png)

![image-20240821174517112](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408211745406.png)

### 文件共享设置

&emsp;通过前面的方法，我们已经安装上了omv本体和第三方插件库，NC10也已经具备了使用的基本要求。这里我们将设置共享服务，为家庭中的局域网设备提供可用于存储、传输、中转及挂载等功能。这其中使用比较广泛的有三种，分别是SMB、NFS和Webdav，根据个人需求设置开启即可。

#### 设置共享文件夹

&emsp;要开启文件共享服务，前提是需要设置一个用于共享的"文件夹"，这里的"文件夹"不是特指某一个目录，它可以是一整个磁盘。

&emsp;回忆一下，我们安装Debian系统时对"分区方案"的操作，一个是"TF卡/U盘为系统盘"，本地磁盘作为数据盘；另一个是"本地磁盘为系统盘"，单独开辟一个分区做"/home"目录。正因为OMV出于对数据的保护，采用了系统空间和用户数据空间分离的设计，所以我才建议采用这两种方案分区。

&emsp;不论是上面的哪种方案，只要系统和数据不在一个磁盘或磁盘分区，就可以将未存放系统的磁盘或分区设置为"共享文件夹"。而分区方案选"本地磁盘为系统盘"，并单独开辟一个分区做"/home"目录的，下方内容可以跳过第一、二步，直接进入第三步，只需调整第三步"文件系统"选项，选择"/home"即可。

> **第一步：查看硬盘信息**
>
> 首先，展开"存储器"，接着点击"磁盘"项进入设置页。
>
> 然后，通过磁盘"型号"和"容量"识别需要设置共享的磁盘；
>
> 最后，记住设备名，例如 /dev/sdb ；这是我要作为数据盘的500G硬盘。

![image-20240822015325002](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408220153303.png)

> **第二步：挂载文件系统**
>
> 首先，展开"存储器"，接着点击"文件系统"项进入设置页。
>
> 然后，点击页面中的"+"号，创建"EXT4"格式文件系统；"设备"选刚记住的设备名，例如 /dev/sdb磁盘。
>
> 最后，在上方保存后，会跳转"挂载"，只需要选中刚创建的文件系统“/dev/sdb1”后，保存并应用改变即可挂载成功。可以填写一个标签来提示此“文件系统”的作用。

![image-20240822020155824](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408220201103.png)

![image-20240822020645472](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408220206728.png)

![image-20240822021754842](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408220217143.png)

> **第三步：创建共享文件夹**
>
> 首先，展开"存储器"，接着点击"共享文件夹"项进入设置页。
>
> 接着，点击页面中的"+"号，进入创建页面。
>
> 然后，按顺序填入信息；
>
> > **"相对路径"**：默认为" 名称/ "，不需改动。当只填入“ / ” 即共享整个"文件系统"；填入“ /目录名/ ”，可省略根目录的" / "，例如 “500G/”，表示共享"文件系统"下名为"500G"的目录及其所有文件；也可以只共享某个目录的子目录及其所有文件，只需要添加路径即可，例如  "500G/share"、"500G/smb"等。
>>
> > **"权限"**：保持默认即可，"其他"也设置为"读/写"，可以为匿名用户使用共享内容提供读、存、改、删的权限。因缺乏安全性，建议只在不涉及隐私数据的目录使用，例如  临时存取目录、文件下载目录等。
>
> 最后，保存并应用改变。
>

![image-20240823021520769](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408230215069.png)

> **第四步：覆写密码**
>
> 这一步很关键，是为了让普通用户挂载刚创建的"共享文件夹"时，能够使用"用户名"和"密码"进行登录。
>
> 在"用户"设置页中编辑自己设置的普通用户，例如 user ；只需要在"密码"行重新输入一次普通用户的登录密码，然后保存并应用改变即可。之后登陆时使用此账号即可登录smb。
>

![image-20240822032455934](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408220324281.png)

&emsp;将OMV系统所在空间设置为共享文件夹。可能你也发现了，前面的设置方法只能将系统空间以外的分区为"共享文件夹"。当你想要将根目录设为共享亦或是单磁盘三分区时(即 boot、根分区、swap)，就会发现似乎并没有选项可供操作。其实，第三方插件库早已经帮你想好应对方法，只需安装一个名为"sharerootfs"的插件，就可以共享根文件系统。

> 第一步：展开"系统"栏，进入“插件”页，搜索"sharerootfs"，选中并安装；
>
> 第二步：按照前面所讲的方法 "第三步" "第四步" 进行后面的共享设置，将"共享文件夹"创建页面中的"设备"选择为根目录即可。

![image-20240822035107126](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408220351440.png)

#### 开启SMB服务

&emsp;要论跨平台和易用性，smb协议当仁不让。在Windows的网络邻居中可以直接发现局域网中的SMB共享资源，一点即连，不需要三方客户端；而在linux、Mac、iOS上，通过自带的文件管理器输入服务器ip地址，也可以方便的连接上SMB共享；至于Android系统，支持smb的文件管理器更是不胜枚举。所以图省事、跨平台，三种共享协议中必启用SMB服务。

&emsp;并且，在“硬件信息篇”我也放出了Windows通过SMB协议，上传下载的传输速度，有线情况下几乎是稳定在30m/s上下，作为一个轻NAS，显然也已经达到能用的水平了。

设置步骤：

> 第一步：先展开"系统"栏，再展开"SMB/CIFS"项，然后进入"共享"设置界面，最后点击"+"进入创建页；
>
> 第二步：修改以下几项，其他可以看需求，或保持默认；
>
> > "Shared folder"：选择之前创建的共享文件夹，例如 500G；
> >
> > "公开"：根据需求选即可；
> >
> > > Tips：-- 选 '否' ，需要用户和密码登录后才可以访问、编辑共享资源；
> > >
> > > ​	   -- 选'允许访客'，允许匿名登录，但不能编辑资源，除非"其他"为"读/写"权限；
> > >
> > > ​	   -- 选"仅访客"，无论是否登录，都视为访客身份，没有编辑共享文件的权限。
> >
> > "继承权限"：勾选上；主要应用于多用户账户场景，避免文件权限、归属混乱，个人使用可以不勾选。

![image-20240822225158861](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408222251142.png)

> 第三步："共享"部分设置完并保存之后，进入"设置"界面，勾选"已启动"和"继承权限"，
>
> 第四步：页面往下来到"高级设置"，最低协议版本建议选择SMB2.0，原因是有些系统、软件、APP不能识别SMB3.0，导致连接失败的情况时有发生，而1.0速度又太低了，毫无意义。
>
> 第五步：保存并应用改变。

![image-20240822224511905](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408222245029.png)

帮助文档：[openmediavault 7.x.y —SMB共享](https://docs.openmediavault.org/en/latest/administration/services/samba.html)  |  []()

#### 开启NFS服务

&emsp;经过长时间使用的情况来看，SMB协议在Windows下的表现很出色，不过在linux系统中传输文件时，却不能跑到满速，上限大约在20~25m/s的样子，暂不清楚是由于什么原因导致的。反观挂载NFS时，上下行的速度几乎能跟Windows下的速度不分伯仲，甚至略有胜出，多数能有35m/s。

&emsp;只不过我使用linux系统的机会非常少，多数只是临时从nas下载文件，传输与我而言并不是刚需，20~25m/s的速度也是可以接受的，这里开启NFS是作为SMB的补充，为padavan路由器、linux系统提供NAS上download和Video目录的挂载条件。

&emsp;故此处只展示如何添加download文件夹的NFS共享，其他的文件夹和磁盘设置方法一致，调整共享文件夹的"相对路径"即可。

设置步骤：

> 第一步：创建一个"download"目录的共享文件夹
>
> > 由于之前我们只创建了一个500G的共享文件夹，想要继续设置download目录共享，还需要在手动建立一个download共享目录；
> >
> > 首先，回到"共享文件夹"创建页，"相对路径"填入"500G/download/" ，这里的含义是将我们原来的"500G"共享文件夹下的目录"download"作为新的共享文件夹，当没有此目录时会自动创建。如果需要一个全新的并且独立于"500G"之外的download目录，可以在"文件系统"的根目录上建立一个与"500G"平级的目录，例如 "download/"；
> >
> > 然后，保存。

![image-20240824142614953](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408241426831.png)

> 第二步：赋予“nobody”用户"读写"权限
>
> > 首先，当上一步设置完会自动回到"共享文件夹"设置界面，选中"download"的并进入"访问控制列表"设置页；
> >
> > 接着，来到页面最下方，看到"访问控制列表"；搜索框中输入“nobody”
> >
> > 之后，确认是用户名"nobody"，在后面点击“Read/Write”，赋予其读写权限。
> >
> > 最后，保存。

![image-20240824160408796](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408241604084.png)

![image-20240824161219455](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408241612761.png)

> 第三步：创建"download"目录的NFS共享
>
> > 首先，展开"服务"栏，再展开"NFS"项，之后进入"共享"设置界面，点击"+"进入创建页
> >
> > 之后，按顺序填入下方信息；
> >
> > > "Shared folder"：选择刚创建的download的共享文件夹；
> > >
> > > "客户端"：填入任意符"*"号，表示所有网段的设备都可以连接此目录；
> > >
> > > "权限"：选择可"读/写"；
> > >
> > > "扩展选项"：rw,async,insecure,no_subtree_check,all_squash,anonuid=65534,anongid=65534 ；其中"anonuid="、"anongid="的数值，可以在命令行输入"id nobody"查询本机nobody的值替换；
> > >
> > > "标签"：填"download"，也可以不填。
> >
> > 最后，保存刚刚的设置。

![image-20240824143642488](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408241436819.png)

> 第四步：启动NFS服务
>
> > 首先，"已启动"：勾选上；
> >
> > 接着，"版本"：勾选上v2，v3，v4；其他的不要勾选，会出现"无权限连接"报错，导致smb无法通过"共享发现"、"网上邻居"进行连接。
> >
> > 最后，保存
>
> 第五步：应用改变。

![image-20240824145357486](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408241453748.png)

帮助文档：[openmediavault 7.x.y ——NFS共享](https://docs.openmediavault.org/en/latest/administration/services/nfs.html)  |  []()

#### 开启Webdav服务

&emsp;Webdav是前两种协议不支持同步的一种补充，它的用途也很广泛，而我启用它是为了Chrome的书签、油猴脚本等本地自动备份。而要开启这一服务，则需要我们安装一个omv的webdav插件。

设置步骤：

> 第一步：创建一个共享文件夹。
>
> &emsp;创建一个用于webdav共享的目录，例如 存放笔记的"500G/note/"；亦可以是已共享的“共享文件夹”目录，例如"500G/"；更可以是与"500G/"平级的目录"note/"；演示用 "500G/note/"。

![image-20240825033401645](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250334974.png)

> 第二步：赋予权限。
>
> &emsp;上一步保存后，会自动跳转自"共享文件夹"设置界面，选中刚创建的"note"，进入"访问控制列表"；
>
> &emsp;下拉至网页下方的"文件访问控制列表"，搜索框输入"www"，找到"www-data"，点击赋予“Read/Write”读与写权限后保存。

![image-20240825033849297](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250338578.png)

![image-20240825034312194](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250343501.png)

> 第三步：安装插件。
>
> &emsp;进入"插件"页，搜索“webdav”，安装“openmediavault-webdav”插件。

![image-20240825041227779](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250412085.png)

> 第四步：开启Webdav服务。
>
> &emsp;安装插件后，展开"服务"栏，进入webdav设置界面，按顺序填写信息，其中的"用户组需"选择"webdav-users；“扩展选项”需填入“charset utf-8;” 网页端才能显示中文内容。

![202408250347268](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250546688.png)

> 第六步：添加成员。
>
> &emsp;进入“用户”栏的"用户组"项，编辑"webdav-users"用户组，在成员处添加一个普通用户，例如 user。之后保存并应用改变。

![image-20240825035749875](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250357165.png)

> 第七步：登录与挂载
>
> &emsp;目前已知问题：网页端无法直接使用，需要使用客户端连接；
>
> &emsp;地址：http://your-host-IP/webdav ；例如 http://192.168.1.54/webdav
>
> &emsp;用户名：user	密码：1234
>
> &emsp;配置文件地址：/etc/nginx/openmediavault-webgui.d/openmediavault-webdav.conf

### 自动化设置

&emsp;OMV提供直观易用的定时服务设置界面，相比于命令行的cron大大方便了我这样的普通用户使用。登录WebUI后，依次点击“系统”-->"计划任务"-->"创建"，即可添加新的定时任务。而利用好定时任务，可以解放我们大量执行重复动作的时间，后面提供几个我频繁使用的场景。

![image-20240820002232905](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240820002232905.png)

#### 开机后自动关闭屏幕

&emsp;前面我们甚至了盒盖不休眠是为了让笔记本不占空间，但是盖子合上后屏幕仍是亮的，而且亮度越大功耗就越高。当我们只是将NC10作为一台服务器/NAS来使用时，几乎很少能用到它的屏幕，大多数还是通过SSH远程登录跟命令行打交道，或者是通过WebUI进行操作，这时关闭屏幕减少功耗相当有必要，实测关闭屏幕可以使NC10的功耗下降6~8w。

&emsp;Debian系统并没有安装桌面环境，无法通过GUI或快捷键来调整亮度，需要通过一句命令来实现关屏目的，不过每次开机都会重新激活屏幕，需要重新执行一次命令。像这样每次都要手敲命令关屏那是相当费事儿，这时我们只要在计划任务中添加一条 定时任务，就可以解放双手啦。

**定时任务：**

> 勾选：已启动
>
> 执行时间：在重启时
>
> 用户：root
>
> 命令：sleep 20 && setterm --blank force --term linux </dev/tty1
>
> tips：命令含义是在每次开机或重启时，等待进程加载完成的20s后关闭屏幕。

![image-20240820231448550](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408202314841.png)

参考文档：[linux 通过命令行(包括ssh)关闭屏幕](https://www.cnblogs.com/dirgo/p/17376210.html)

#### 应用程序定期自动更新

&emsp;同样的，我们想让NC10的程序保持最新状态，但又不想每次都手动更新，我们只需要添加一条每周自动更新程序的定时任务，那之后程序更新几乎就不需要你管理了，只要是通过apt安装的软件包/依赖，就会自动升级。

**定时任务：**

> 勾选：已启动
>
> 执行时间：特定日期
>
> 分：0分
>
> 时：3
>
> 周内第几天：星期二
>
> 用户：root
>
> 命令：apt update && apt upgrade -y && apt autoclean && apt autoremove  -y
>
> > Tips：命令会在"每周二" , "凌晨3点"，自动更新程序并清理无用软件包，其中的时间任意调整即可，可以每周两天或三天，亦或是每天。
> >
> > 要注意一点，当更新OMV相关程序时（目前仅遇到升级OMV版本），需要在WebUI手动"应用"改变，这一点目前还没有好的办法实现自动"应用"，但这种变化性的更新并不多见。

> 设置完成后，保存并应用改变。

![image-20240820020245783](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408200202120.png)

#### 系统定期自动备份

&emsp;OMV本身并没有提供备份的功能，但是在插件库中却有丰富的备份方案。我们用到的是"openmediavault-backup"这款插件，借助它可以轻松实现定期对系统分区的备份，其中提供了"dd"、"dd full disk"、"fsarchiver"、"borgbackup"、"rsync" 五种备份方式，每种方式都各具特点。个人比较推荐的是"fsarchiver"和"borgbackup"，前者有着高压缩率、备份的文件体积小的特点，恢复方式也不难；而后者不仅有着较高的压缩率还支持增量备份，对大体积的系统盘频繁备份比较友好，恢复更简单并且支持部分文件恢复。

**fsarchiver备份**：[OMV 系统自动备份工具 fsarchiver 教程](https://songming.me/openmediavault-backup-fsarchiver-setup.html)

**borgbackup备份**

设置步骤：

> 第一步，创建一个用于放置系统备份文件的"共享文件夹 - system_backup"。
>
> > 进入共享文件夹的"创建"页，按顺序填入信息，可参考下图。
> >
> > “文件系统”建议是选择一个独立的磁盘/U盘/TF卡的介质，如果没有也没关系，也可以存放在独立的分区"/home"下面，建立名为"system_backup"的文件夹，易于识别。

![image-20240825014619671](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250146974.png)

> 第二步：安装插件“openmediavault-backup”。进入"插件"，搜索"backup"，选中并安装它。

![image-20240825015211751](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250152087.png)

> 第三步：插件安装后，"系统"栏下多出一个"备份"项，展开并进入"设置"界面。
>
> > 参考图中进行填写。
> >
> > borgbackup备份过程中会排除"/export"、"/srv"目录，若你是将系统备份文件存放在了"/home/system_backup"下，并且需要备份"/home"目录下的用户数据，那么“扩展选项”这一行就需要填入“--exclude=/home/system_backup”排除掉它，以免重复备份。

![image-20240825015744340](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250157657.png)

> 第四步：创建定时任务。按图所示为每个月的每周二、周五凌晨4点30分，执行备份程序，时间自定义。

![image-20240825020650856](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250206190.png)

> 第五步：来到”系统“栏下的"计划任务"，选中"/usr/sbin/omv-backup"并试运行依次，看是否有错误。

![image-20240825021111848](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250211152.png)

**恢复文件：**

> 首先，进入"共享文件夹"中获取备份目录"system_backup"的绝对路径，即“/srv/dev-disk-by-uuid-62d56451-08bf-4d0f-922e-7e00fd80c721/system_backup”；完整路径为：“绝对路径/omvbackup/borgbackup/”
>
> 接着，列出备份信息和详细信息；"archive"是备份存档的名称
>
> > borg list 绝对路径/omvbackup/borgbackup

```
# 以列表的形式展示存档信息
borg list /srv/dev-disk-by-uuid-62d56451-08bf-4d0f-922e-7e00fd80c721/system_backup/omvbackup/borgbackup

# 展示更详细的存档信息
borg list --json /srv/dev-disk-by-uuid-62d56451-08bf-4d0f-922e-7e00fd80c721/system_backup/omvbackup/borgbackup
```

> 然后，查看存档列表，都包含哪些已备份的文件信息和目录信息；确认需要复原的目录。
>
> > borg list 绝对路径/omvbackup/borgbackup::"archive"

```
borg list /srv/dev-disk-by-uuid-62d56451-08bf-4d0f-922e-7e00fd80c721/system_backup/omvbackup/borgbackup::backup-omv-2024-08-24_22-21-54
```

> 最后，使用"bofg extract"恢复文件；
>
> backup=绝对路径/omvbackup/borgbackup

```
# 存档解压到当前目录
borg extract -v --list $backup/::"archive"

示例e：borg extract -v --list /srv/dev-disk-by-uuid-62d56451-08bf-4d0f-922e-7e00fd80c721/system_backup/omvbackup/borgbackup::backup-omv-2024-08-24_22-21-54


# 使用"--dry-run"参数模拟提取，展示过程
borg extract --dry-run -v --list $backup/::"archive"

示例e：borg extract --dry-run -v --list /srv/dev-disk-by-uuid-62d56451-08bf-4d0f-922e-7e00fd80c721/system_backup/omvbackup/borgbackup::backup-omv-2024-08-24_22-21-54


# 通过传递目录名称从存档中提取特定目录
borg extract -v --list $backup/::"archive" /path/file

示例e：borg extract -v --list /srv/dev-disk-by-uuid-62d56451-08bf-4d0f-922e-7e00fd80c721/system_backup/omvbackup/borgbackup::backup-omv-2024-08-24_22-21-54 /home/user/
```

参考文档：[快速入门 — Borg - Deduplicating Archiver 1.4.0 文档](https://borgbackup.readthedocs.io/en/stable/quickstart.html#restoring-a-backup) | [如何在 Linux 中使用 BorgBackup 备份和恢复文件](https://www.modb.pro/db/220215)

**五种备份方式的三次简单对比：**

> dd - 使用 dd 克隆系统分区并压缩为镜像文件。
>
> dd full disk - 使用 dd 克隆选中磁盘到压缩镜像文件。
>
> fsarchiver - 使用 fsarchiver 克隆系统分区到归档文件。
>
> borgbackup - 使用 borgbackup 备份系统到归档文件。
>
> rsync - 使用 rsync 同步文件到目标路径。

&emsp;三次备份的差别：第一次备份作为标定，看压缩后体积和压缩率；第二次为不增加内容，原文件备份各备份一次，看各个方式的体积变化；第三次增加1G文件再备份，看体积。

&emsp;前三种不支持增量备份，每次备份体积都会成倍增长，所以需要设置定期自动清理，其中fsarchiver有个高压缩率，单次备份的体积最小。后两种都支持增量备份，多次备份的体积增长不会成倍增长，比较解决空间，但rsync本身并没有进行压缩，故体积是所有方式中最大的。

![image-20240824204552539](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408242045825.png)

![image-20240824211253814](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408242112108.png)

![image-20240824230333523](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408242303842.png)

### 仪表盘显示CPU温度

![image-20240820195937756](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408201959038.png)

&emsp;当我们有了一个NAS或者叫服务器以后，或多或少会希望能有一个面板来展示设备当前运行的基本状态，了解它的服务是否正常，内存、CPU、硬盘的温度高低与使用情况。如上图所示，OMV的仪表盘就能满足这些简单需求，也许是观赏价值大于使用价值，但谁又能拒绝登录后展现在眼前的动态数据图标带来的小小愉悦呢(￣▽￣)~*

&emsp;第一次登录时，可以在首页的“仪表盘”直接设置要展示的内容，之后调整则可以通过右上角的”用户设置“进行调整，几乎没有什么难度。唯有一点，CPU的温度显示并没有直接集成在仪表盘中，需要另外安装一个”cputemp“的插件，之后才能够在”仪表盘“中增加卡片。

**安装温度插件：**

> 登录WebUI，展开“系统”栏，点击进入"插件"目录；
>
> 搜索框输入关键词"cpu"，选中“cputemp”并安装它。

![image-20240820202413803](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408202024063.png)

**显示温度卡片：**

> 当你已经设置过仪表盘后，通过“用户设置” 找到“仪表盘”，进入后勾选相应的“CPU Temp”并保存，首页“仪表盘”中就会显示相应核心温度卡片。

![image-20240820203035767](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408202030045.png)

### WebUI启用https登录

&emsp;WebUI登录默认是http协议，即无加密。一般不将NAS暴露到公网环境的话，多数是内网使用也就无需使用https协议了，还有一个原因是“自建证书”并强制https登录每次都会跳出“网站不安全”的提示，需要手动跳转登录页，相当麻烦。

![image-20240820225339578](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408202253843.png)

&emsp;对于需要暴露NAS或者就是喜欢https的用户，OMV也提供了简单方便的设置UI。由于目前我还用不到，只尝试了"自建证书"开启https，过程中也遇到了问题，所以把"自建证书"的细节点记录一下，关于导入部分等以后买了域名再尝试吧。

**自建证书：**

> 首先，展开"系统"栏下的"证书"，点击"SSL"进入设置界面，选择"创建"；
>
> 接着，按照设置中的提示，任意填写其中内容。
>
> 最后，方便快查找可在"标签"处填一个容易辨认的名称，当证书比较多时，可以一眼便认出。此处给OMV创建，故取名OpenMediaVault。
>
> 重点：众多内容中，唯一要注意的是“密钥长度”请选择"2048"，因为选择“4096”有可能会出现"504 - Gateway Time-out"的报错，以至于无法创建证书，这也许与N270的CPU有关系，所以不要遗漏这一点，其他的。

> 创建的证书位置："/etc/pki/tls/certs" | "/etc/ssl/private" | "/etc/pki/tls/certs"

![image-20240820214900443](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408202149770.png)

**启用https：**

> 首先，展开"系统"栏，点击进入"工作台" ；
>
> 其次，勾选"已启用SSL/TLS" ；
>
> 接着，选择刚创建的证书，例如 OpenMediaVault ；
>
> 然后，勾选"强制使用SSL/TLS" ；
>
> 最后，保存并应用设置。

![image-20240820215459745](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408202155020.png)

### TF卡/U盘保护

&emsp;我的NC10启动盘使用的是TF卡，为了延长它的寿命，减少因频繁写入造成的损耗，需要安装一款"flashmemory"的插件，它会将一些临时文件写入到内存中，减少TF卡/U盘的次数，从而达到保护他们的目的。

步骤：

> 首先，进入到"插件"安装页面；
>
> 接着，搜索关键字"flash"，定位到"flashmemory"，并将其安装。
>
> 最后，进入"服务"栏下的"Flashmemory"项，查看"状态"一行，当显示为"running"时，表示正在运行。

![image-20240825080343396](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250803747.png)

![image-20240825081356245](https://cdn.jsdelivr.net/gh/GKK2024/Convert-an-NC10-into-a-NAS@main/Images/202408250813549.png)
