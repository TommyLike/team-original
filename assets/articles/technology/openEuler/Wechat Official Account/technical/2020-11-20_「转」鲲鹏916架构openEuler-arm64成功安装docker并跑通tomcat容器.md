# [「转」鲲鹏916架构openEuler-arm64成功安装docker并跑通tomcat容器](https://mp.weixin.qq.com/s/8ibTkSuyvZRrY4zHqjaFfQ)

*coding*[OpenAtom openEuler](javascript:void%280%29;)*2020-11-20 12:00:00*

本文是基于之前这篇文章

## 鲲鹏920架构arm64版本centos7安装docker

https://blog.csdn.net/frdevolcqzyxynjds/article/details/106070513

# 下面开始

- 先来看下系统版本![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjelawmS4mheSPYP05uXcRdrwqBYhETrroUXRX2an5fibviabwlHn7LKqQ/640?wx_fmt=png)
- 卸载旧版本 旧版本的 Docker 称为  docker  或者  docker-engine  ，使用以下命令卸载旧版本：

```
yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine
```

![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjOg2icgB2pwLOUwlMyoamy9ezEviaSYeS9akKDPW8Kr76aaPK1Yr4Rrtg/640?wx_fmt=png)

在这里插入图片描述

- 配置openEuler更新源

```
hostnamectl 

yum repolist 

cat>"/etc/yum.repos.d/openEuler_aarch64.repo"<<EOF
[base]
name=EulerOS-2.0SP8 base
baseurl=http://mirrors.huaweicloud.com/euler/2.8/os/aarch64/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.huaweicloud.com/euler/2.8/os/RPM-GPG-KEY-EulerOS
EOF

cat /etc/yum.repos.d/openEuler_aarch64.repo

yum clean all 

yum makecache 

yum repolist 
```

![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjIe8SSYpRibyKYbYU4BL4YTyQzHQtRnAlC5GZ8jllr7r1DxzM6fApSwQ/640?wx_fmt=png)![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjFZhIWNrGze9ficvatVL5s0ibQbAndMZs8XCvC27RojZTU0AzWA3HH2iaQ/640?wx_fmt=png)配置 Docker YUM 源

```
vim docker-ce.repo
```

```
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-stable-debuginfo]
name=Docker CE Stable - Debuginfo $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/debug-$basearch/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/source/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-edge]
name=Docker CE Edge - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/$basearch/edge
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-edge-debuginfo]
name=Docker CE Edge - Debuginfo $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/debug-$basearch/edge
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-edge-source]
name=Docker CE Edge - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/source/edge
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-test]
name=Docker CE Test - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-test-debuginfo]
name=Docker CE Test - Debuginfo $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/debug-$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-test-source]
name=Docker CE Test - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/source/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-nightly]
name=Docker CE Nightly - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/$basearch/nightly
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-nightly-debuginfo]
name=Docker CE Nightly - Debuginfo $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/debug-$basearch/nightly
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
 
[docker-ce-nightly-source]
name=Docker CE Nightly - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/source/nightly
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
```

生成缓存

```
yum makecache
```

![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjyhJNwQcibuFicFgTDaopqbOQpV4gaDbju0fdpJT1CA03m6e1dsUskWNg/640?wx_fmt=png)查看仓库列表![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjoVbSDXsFHlO8liam1HicTRKTN8giafUDd7uEGdPVDy172p3pCqaicuicE9A/640?wx_fmt=png)以上搞定yum源之后 执行以下命令安装依赖包：

```
yum install -y yum-utils \
device-mapper-persistent-data \
lvm2
```

![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwj0MT2hIV5c1a84DGsENIdKJia5Vwub1sOc2t0uLhB7dr4kcwsCDYfvbw/640?wx_fmt=png)安装

```
yum -y install docker-ce
```

![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwj4BaNC6XAGdaCY5qSJY6SgDyUJdyyWq8a8TPtYA0yEOFzycn8dh9hhA/640?wx_fmt=png)

在这里插入图片描述

```
wget ./ https://mirrors.huaweicloud.com/centos-altarch/7/extras/aarch64/Packages/container-selinux-2.119.1-1.c57a6f9.el7.noarch.rpm
```

![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjbdyaj5LCAOD1HpicqUGZ99ib6ho6cIydwUIOsCVK27uX9UPHumAwNxiaw/640?wx_fmt=png)

在这里插入图片描述

```
rpm -ivh container-selinux-2.119.1-1.c57a6f9.el7.noarch.rpm
```

```
[root@pc-openeuler-1 ~]# rpm -ivh container-selinux-2.119.1-1.c57a6f9.el7.noarch.rpm
warning: container-selinux-2.119.1-1.c57a6f9.el7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
error: Failed dependencies:
 policycoreutils-python is needed by container-selinux-2:2.119.1-1.c57a6f9.el7.noarch
[root@pc-openeuler-1 ~]#
```

那就给它安装policycoreutils-python

```
yum -y install policycoreutils-python
```

```
[root@pc-openeuler-1 ~]# yum -y install policycoreutils-python
Last metadata expiration check: 0:09:19 ago on Tue 09 Jun 2020 02:07:07 PM CST.
Dependencies resolved.
==============================================================================================================
 Package                       Architecture  Version                                         Repository  Size
==============================================================================================================
Installing:
 python2-policycoreutils       noarch        2.8-8.h1.eulerosv2r8                            base       261 k
Installing dependencies:
 checkpolicy                   aarch64       2.8-2.eulerosv2r8                               base       272 k
 libselinux-utils              aarch64       2.8-4.eulerosv2r8                               base        94 k
 python2-IPy                   noarch        0.81-23.h1.eulerosv2r8                          base        37 k
 python2-audit                 aarch64       3.0-0.4.20180831git0047a6c.h4.eulerosv2r8       base        72 k
 python2-libselinux            aarch64       2.8-4.eulerosv2r8                               base       153 k
 python2-libsemanage           aarch64       2.8-4.eulerosv2r8                               base        70 k
 python2-setools               aarch64       4.1.1-13.h1.eulerosv2r8                         base       560 k
Downgrading:
 audit                         aarch64       3.0-0.4.20180831git0047a6c.h4.eulerosv2r8       base       224 k
 audit-libs                    aarch64       3.0-0.4.20180831git0047a6c.h4.eulerosv2r8       base       105 k
 libselinux                    aarch64       2.8-4.eulerosv2r8                               base        75 k
 libsemanage                   aarch64       2.8-4.eulerosv2r8                               base       105 k
 policycoreutils               aarch64       2.8-8.h1.eulerosv2r8                            base       183 k
 python3-libselinux            aarch64       2.8-4.eulerosv2r8                               base       153 k

Transaction Summary
==============================================================================================================
Install    8 Packages
Downgrade  6 Packages

Total download size: 2.3 M
Downloading Packages:
(1/14): libselinux-2.8-4.eulerosv2r8.aarch64.rpm                              228 kB/s |  75 kB     00:00    
(2/14): audit-libs-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64.rpm      253 kB/s | 105 kB     00:00    
(3/14): libsemanage-2.8-4.eulerosv2r8.aarch64.rpm                             1.0 MB/s | 105 kB     00:00    
(4/14): audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64.rpm           493 kB/s | 224 kB     00:00    
(5/14): python3-libselinux-2.8-4.eulerosv2r8.aarch64.rpm                      2.1 MB/s | 153 kB     00:00    
(6/14): policycoreutils-2.8-8.h1.eulerosv2r8.aarch64.rpm                      1.7 MB/s | 183 kB     00:00    
(7/14): checkpolicy-2.8-2.eulerosv2r8.aarch64.rpm                             2.6 MB/s | 272 kB     00:00    
(8/14): libselinux-utils-2.8-4.eulerosv2r8.aarch64.rpm                        1.2 MB/s |  94 kB     00:00    
(9/14): python2-IPy-0.81-23.h1.eulerosv2r8.noarch.rpm                         601 kB/s |  37 kB     00:00    
(10/14): python2-libselinux-2.8-4.eulerosv2r8.aarch64.rpm                     2.4 MB/s | 153 kB     00:00    
(11/14): python2-libsemanage-2.8-4.eulerosv2r8.aarch64.rpm                    742 kB/s |  70 kB     00:00    
(12/14): python2-setools-4.1.1-13.h1.eulerosv2r8.aarch64.rpm                  5.3 MB/s | 560 kB     00:00    
(13/14): python2-audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64.rpm  266 kB/s |  72 kB     00:00    
(14/14): python2-policycoreutils-2.8-8.h1.eulerosv2r8.noarch.rpm              407 kB/s | 261 kB     00:00    
--------------------------------------------------------------------------------------------------------------
Total                                                                         1.8 MB/s | 2.3 MB     00:01     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                      1/1 
  Running scriptlet: systemd                                                                              1/1 
  Downgrading      : libselinux-2.8-4.eulerosv2r8.aarch64                                                1/20 
  Running scriptlet: cronie                                                                              1/20 
  Downgrading      : audit-libs-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                        2/20 
  Running scriptlet: audit-libs-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                        2/20 
  Downgrading      : libsemanage-2.8-4.eulerosv2r8.aarch64                                               3/20 
  Installing       : python2-libselinux-2.8-4.eulerosv2r8.aarch64                                        4/20 
  Installing       : python2-setools-4.1.1-13.h1.eulerosv2r8.aarch64                                     5/20 
  Installing       : python2-libsemanage-2.8-4.eulerosv2r8.aarch64                                       6/20 
  Installing       : python2-audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                     7/20 
  Installing       : libselinux-utils-2.8-4.eulerosv2r8.aarch64                                          8/20 
  Downgrading      : policycoreutils-2.8-8.h1.eulerosv2r8.aarch64                                        9/20 
  Running scriptlet: policycoreutils-2.8-8.h1.eulerosv2r8.aarch64                                        9/20 
  Installing       : python2-IPy-0.81-23.h1.eulerosv2r8.noarch                                          10/20 
  Installing       : checkpolicy-2.8-2.eulerosv2r8.aarch64                                              11/20 
  Installing       : python2-policycoreutils-2.8-8.h1.eulerosv2r8.noarch                                12/20 
  Downgrading      : audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                            13/20 
  Running scriptlet: audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                            13/20 
  Downgrading      : python3-libselinux-2.8-4.eulerosv2r8.aarch64                                       14/20 
  Running scriptlet: policycoreutils-2.8-11.aarch64                                                     15/20 
  Cleanup          : policycoreutils-2.8-11.aarch64                                                     15/20 
  Running scriptlet: systemd                                                                            15/20 
  Running scriptlet: policycoreutils-2.8-11.aarch64                                                     15/20 
Failed to try-restart restorecond.service: Unit restorecond.service not found.

  Cleanup          : libsemanage-2.9-1.aarch64                                                          16/20 
  Running scriptlet: audit-3.0-5.aarch64                                                                17/20 
  Cleanup          : audit-3.0-5.aarch64                                                                17/20 
  Running scriptlet: audit-3.0-5.aarch64                                                                17/20 
  Cleanup          : python3-libselinux-2.9-1.aarch64                                                   18/20 
  Cleanup          : libselinux-2.9-1.aarch64                                                           19/20 
  Cleanup          : audit-libs-3.0-5.aarch64                                                           20/20 
  Running scriptlet: glibc-common                                                                       20/20 
  Running scriptlet: man-db                                                                             20/20 
  Running scriptlet: systemd                                                                            20/20 
  Running scriptlet: glibc-common                                                                       20/20 
  Verifying        : audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                             1/20 
  Verifying        : audit-3.0-5.aarch64                                                                 2/20 
  Verifying        : audit-libs-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                        3/20 
  Verifying        : audit-libs-3.0-5.aarch64                                                            4/20 
  Verifying        : libselinux-2.8-4.eulerosv2r8.aarch64                                                5/20 
  Verifying        : libselinux-2.9-1.aarch64                                                            6/20 
  Verifying        : libsemanage-2.8-4.eulerosv2r8.aarch64                                               7/20 
  Verifying        : libsemanage-2.9-1.aarch64                                                           8/20 
  Verifying        : policycoreutils-2.8-8.h1.eulerosv2r8.aarch64                                        9/20 
  Verifying        : policycoreutils-2.8-11.aarch64                                                     10/20 
  Verifying        : python3-libselinux-2.8-4.eulerosv2r8.aarch64                                       11/20 
  Verifying        : python3-libselinux-2.9-1.aarch64                                                   12/20 
  Verifying        : checkpolicy-2.8-2.eulerosv2r8.aarch64                                              13/20 
  Verifying        : libselinux-utils-2.8-4.eulerosv2r8.aarch64                                         14/20 
  Verifying        : python2-IPy-0.81-23.h1.eulerosv2r8.noarch                                          15/20 
  Verifying        : python2-audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                    16/20 
  Verifying        : python2-libselinux-2.8-4.eulerosv2r8.aarch64                                       17/20 
  Verifying        : python2-libsemanage-2.8-4.eulerosv2r8.aarch64                                      18/20 
  Verifying        : python2-policycoreutils-2.8-8.h1.eulerosv2r8.noarch                                19/20 
  Verifying        : python2-setools-4.1.1-13.h1.eulerosv2r8.aarch64                                    20/20 

Downgraded:
  audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                                                     
  audit-libs-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                                                
  libselinux-2.8-4.eulerosv2r8.aarch64                                                                        
  libsemanage-2.8-4.eulerosv2r8.aarch64                                                                       
  policycoreutils-2.8-8.h1.eulerosv2r8.aarch64                                                                
  python3-libselinux-2.8-4.eulerosv2r8.aarch64                                                                

Installed:
  python2-policycoreutils-2.8-8.h1.eulerosv2r8.noarch                                                         
  checkpolicy-2.8-2.eulerosv2r8.aarch64                                                                       
  libselinux-utils-2.8-4.eulerosv2r8.aarch64                                                                  
  python2-IPy-0.81-23.h1.eulerosv2r8.noarch                                                                   
  python2-audit-3.0-0.4.20180831git0047a6c.h4.eulerosv2r8.aarch64                                             
  python2-libselinux-2.8-4.eulerosv2r8.aarch64                                                                
  python2-libsemanage-2.8-4.eulerosv2r8.aarch64                                                               
  python2-setools-4.1.1-13.h1.eulerosv2r8.aarch64                                                             

Complete!
[root@pc-openeuler-1 ~]# 
```

然后再来rpm -ivh container-selinux-2.119.1-1.c57a6f9.el7.noarch.rpm

```
[root@pc-openeuler-1 ~]# rpm -ivh container-selinux-2.119.1-1.c57a6f9.el7.noarch.rpm
warning: container-selinux-2.119.1-1.c57a6f9.el7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:container-selinux-2:2.119.1-1.c57################################# [100%]
Conflicting name type transition rules
Binary policy creation failed at /var/lib/selinux/targeted/tmp/modules/200/container/cil:1769
Failed to generate binary
/usr/sbin/semodule:  Failed!
Error loading SELinux module.
/var/tmp/rpm-tmp.sVKKDb: line 12: return: can only `return' from a function or sourced script
[root@pc-openeuler-1 ~]# 

```

查看container-selinux是否安装成功

```
[root@pc-openeuler-1 ~]# rpm -qa | grep container-selinux
container-selinux-2.119.1-1.c57a6f9.el7.noarch
[root@pc-openeuler-1 ~]# 

```

此时再安装docker-ce

yum -y install docker-ce docker-ce-cli containerd.io

```
[root@pc-openeuler-1 ~]# yum -y install docker-ce docker-ce-cli containerd.io
Last metadata expiration check: 0:50:36 ago on Tue 09 Jun 2020 02:07:07 PM CST.
Dependencies resolved.
==============================================================================================================
 Package                 Architecture      Version                           Repository                  Size
==============================================================================================================
Installing:
 containerd.io           aarch64           1.2.13-3.2.el7                    docker-ce-stable            20 M
 docker-ce               aarch64           3:19.03.11-3.el7                  docker-ce-stable            16 M
 docker-ce-cli           aarch64           1:19.03.11-3.el7                  docker-ce-stable            25 M
Installing dependencies:
 libcgroup               aarch64           0.41-20.eulerosv2r8.h1            base                        61 k
 tar                     aarch64           2:1.30-6.h2.eulerosv2r8           base                       801 k

Transaction Summary
==============================================================================================================
Install  5 Packages

Total download size: 62 M
Installed size: 289 M
Downloading Packages:
(1/5): docker-ce-cli-19.03.11-3.el7.aarch64.rpm                               7.4 MB/s |  25 MB     00:03    
(2/5): containerd.io-1.2.13-3.2.el7.aarch64.rpm                               2.0 MB/s |  20 MB     00:10    
(3/5): docker-ce-19.03.11-3.el7.aarch64.rpm                                   1.6 MB/s |  16 MB     00:10    
(4/5): libcgroup-0.41-20.eulerosv2r8.h1.aarch64.rpm                           6.5 kB/s |  61 kB     00:09    
(5/5): tar-1.30-6.h2.eulerosv2r8.aarch64.rpm                                  1.1 MB/s | 801 kB     00:00    
--------------------------------------------------------------------------------------------------------------
Total                                                                         4.6 MB/s |  62 MB     00:13     
warning: /var/cache/dnf/docker-ce-stable-b401a908f39b682f/packages/containerd.io-1.2.13-3.2.el7.aarch64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Docker CE Stable - aarch64                                                     18 kB/s | 1.6 kB     00:00    
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35
 From       : https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                      1/1 
  Installing       : tar-2:1.30-6.h2.eulerosv2r8.aarch64                                                  1/5 
  Running scriptlet: libcgroup-0.41-20.eulerosv2r8.h1.aarch64                                             2/5 
  Installing       : libcgroup-0.41-20.eulerosv2r8.h1.aarch64                                             2/5 
  Installing       : docker-ce-cli-1:19.03.11-3.el7.aarch64                                               3/5 
  Running scriptlet: docker-ce-cli-1:19.03.11-3.el7.aarch64                                               3/5 
  Installing       : containerd.io-1.2.13-3.2.el7.aarch64                                                 4/5 
  Running scriptlet: containerd.io-1.2.13-3.2.el7.aarch64                                                 4/5 
  Installing       : docker-ce-3:19.03.11-3.el7.aarch64                                                   5/5 
  Running scriptlet: docker-ce-3:19.03.11-3.el7.aarch64                                                   5/5 
  Running scriptlet: glibc-common                                                                         5/5 
  Running scriptlet: man-db                                                                               5/5 
  Running scriptlet: systemd                                                                              5/5 
  Verifying        : containerd.io-1.2.13-3.2.el7.aarch64                                                 1/5 
  Verifying        : docker-ce-3:19.03.11-3.el7.aarch64                                                   2/5 
  Verifying        : docker-ce-cli-1:19.03.11-3.el7.aarch64                                               3/5 
  Verifying        : libcgroup-0.41-20.eulerosv2r8.h1.aarch64                                             4/5 
  Verifying        : tar-2:1.30-6.h2.eulerosv2r8.aarch64                                                  5/5 

Installed:
  containerd.io-1.2.13-3.2.el7.aarch64                 docker-ce-3:19.03.11-3.el7.aarch64                    
  docker-ce-cli-1:19.03.11-3.el7.aarch64               libcgroup-0.41-20.eulerosv2r8.h1.aarch64              
  tar-2:1.30-6.h2.eulerosv2r8.aarch64                 

Complete!
[root@pc-openeuler-1 ~]# 
[root@pc-openeuler-1 ~]#
```

安装完成

下面查看docker状态并启动docker服务

systemctl status docker

```
[root@pc-openeuler-1 ~]# systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: https://docs.docker.com
[root@pc-openeuler-1 ~]# 
[root@pc-openeuler-1 ~]# systemctl start docker 
[root@pc-openeuler-1 ~]# 
[root@pc-openeuler-1 ~]# systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2020-06-09 15:02:24 CST; 2min 49s ago
     Docs: https://docs.docker.com
 Main PID: 63001 (dockerd)
    Tasks: 13
   Memory: 46.6M
   CGroup: /system.slice/docker.service
           └─63001 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Jun 09 15:02:12 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:12.502107011+08:00" level=info msg="sch>
Jun 09 15:02:12 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:12.502157031+08:00" level=info msg="ccR>
Jun 09 15:02:12 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:12.502197891+08:00" level=info msg="Cli>
Jun 09 15:02:16 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:16.176454924+08:00" level=info msg="Loa>
Jun 09 15:02:18 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:18.930313224+08:00" level=info msg="Def>
Jun 09 15:02:19 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:19.583828932+08:00" level=info msg="Loa>
Jun 09 15:02:22 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:22.433972647+08:00" level=info msg="Doc>
Jun 09 15:02:22 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:22.435054350+08:00" level=info msg="Dae>
Jun 09 15:02:24 pc-openeuler-1 dockerd[63001]: time="2020-06-09T15:02:24.185022216+08:00" level=info msg="API>
Jun 09 15:02:24 pc-openeuler-1 systemd[1]: Started Docker Application Container Engine.
```

查看docker版本

```
[root@pc-openeuler-1 ~]# docker --version
Docker version 19.03.11, build 42e35e6
[root@pc-openeuler-1 ~]#
```

配置docker镜像加速器 vim /etc/docker/daemon.json

```
[root@pc-openeuler-1 ~]# cat /etc/docker/daemon.json
{
 "registry-mirrors":["https://bjtzu1jb.mirror.aliyuncs.com"]      
}
[root@pc-openeuler-1 ~]#
```

然后 systemctl daemon-reload & systemctl restart docker

```
[root@pc-openeuler-1 ~]# systemctl daemon-reload & systemctl restart docker
[1] 63447
[1]+  Done                    systemctl daemon-reload
[root@pc-openeuler-1 ~]# 
[root@pc-openeuler-1 ~]#
```

查看docker状态 systemctl status docker

```
[root@pc-openeuler-1 ~]# systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2020-06-09 15:24:03 CST; 1min 24s ago
     Docs: https://docs.docker.com
 Main PID: 63475 (dockerd)
    Tasks: 13
   Memory: 44.4M
   CGroup: /system.slice/docker.service
           └─63475 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Jun 09 15:22:40 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:22:34.795222782+08:00" level=warning msg=">
Jun 09 15:22:41 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:22:40.309131328+08:00" level=warning msg=">
Jun 09 15:22:44 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:22:44.015576800+08:00" level=info msg="Def>
Jun 09 15:23:08 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:23:07.695242422+08:00" level=warning msg=">
Jun 09 15:23:29 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:23:28.740818470+08:00" level=warning msg=">
Jun 09 15:23:29 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:23:29.926221673+08:00" level=info msg="Loa>
Jun 09 15:24:02 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:24:02.030817793+08:00" level=info msg="Doc>
Jun 09 15:24:02 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:24:02.062519458+08:00" level=info msg="Dae>
Jun 09 15:24:03 pc-openeuler-1 dockerd[63475]: time="2020-06-09T15:24:03.192702752+08:00" level=info msg="API>
Jun 09 15:24:03 pc-openeuler-1 systemd[1]: Started Docker Application Container Engine.


[root@pc-openeuler-1 ~]#
```

然后测试一哈，拉取tomcat

```
[root@pc-openeuler-1 ~]# docker pull tomcat  
Using default tag: latest
latest: Pulling from library/tomcat
d23bf71de5e1: Pull complete 
d4f6b089b352: Pull complete 
f34690136adb: Pull complete 
4287f76f52e4: Pull complete 
bc5d569bcb57: Pull complete 
1a677fbcec14: Pull complete 
1c8a38f60034: Pull complete 
1f9869d8b524: Pull complete 
2374f3e92c6e: Pull complete 
eb4f14fdf058: Pull complete 
Digest: sha256:ce753be7b61d86f877fe5065eb20c23491f783f283f25f6914ba769fee57886b
Status: Downloaded newer image for tomcat:latest
docker.io/library/tomcat:latest
[root@pc-openeuler-1 ~]# 

```

查看镜像

```
[root@pc-openeuler-1 ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
tomcat              latest              929551858872        3 weeks ago         638MB
[root@pc-openeuler-1 ~]#
```

创建并启动tomcat容器

```
[root@pc-openeuler-1 ~]# docker run -d --name tomcat -p 80:8080 -v /root/software:/usr/local/tomcat/webapps tomcat:latest     
8921b9b4251662019268e1a2142c9ccf0cf9ea748d692bccb14b86b65b279c83
[root@pc-openeuler-1 ~]# 
```

查看docker容器进程

```
[root@pc-openeuler-1 ~]# docker ps -a                                                                                    
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
8921b9b42516        tomcat:latest       "catalina.sh run"   23 minutes ago      Up 21 minutes       0.0.0.0:80->8080/tcp   tomcat
```

进入docker容器

```
[root@pc-openeuler-1 ~]# docker exec -it 892 /bin/bash

Message from syslogd@pc-openeuler-1 at Jun  9 17:41:14 ...
 kernel:[2477522.858676] watchdog: BUG: soft lockup - CPU#0 stuck for 21s! [multipathd:1257]
root@8921b9b42516:/usr/local/tomcat#
```

往下做好心理准备，会很卡很慢，但是最后通了

```
root@8921b9b42516:/usr/local/tomcat# ls -l
total 184
-rw-r--r--. 1 root root 18982 May  5 20:40 BUILDING.txt
-rw-r--r--. 1 root root  5409 May  5 20:40 CONTRIBUTING.md
-rw-r--r--. 1 root root 57092 May  5 20:40 LICENSE
-rw-r--r--. 1 root root  2333 May  5 20:40 NOTICE
-rw-r--r--. 1 root root  3255 May  5 20:40 README.md
-rw-r--r--. 1 root root  6898 May  5 20:40 RELEASE-NOTES
-rw-r--r--. 1 root root 16262 May  5 20:40 RUNNING.txt
drwxr-xr-x. 2 root root  4096 May 16 16:34 bin
drwxr-xr-x. 1 root root  4096 Jun  9 07:59 conf
drwxr-xr-x. 2 root root  4096 May 16 16:34 lib
drwxrwxrwx. 1 root root  4096 Jun  9 07:59 logs
drwxr-xr-x. 2 root root  4096 May 16 16:34 native-jni-lib
drwxrwxrwx. 2 root root  4096 May 16 16:34 temp
drwxr-xr-x. 2 root root  4096 Jun  9 07:55 webapps
drwxr-xr-x. 7 root root  4096 May  5 20:37 webapps.dist
drwxrwxrwx. 2 root root  4096 May  5 20:36 work
root@8921b9b42516:/usr/local/tomcat# 
root@8921b9b42516:/usr/local/tomcat# mv webapps.dist/* webapps
```

```
root@8921b9b42516:/usr/local/tomcat# ls -l webapps.dist/
total 0
root@8921b9b42516:/usr/local/tomcat# 
root@8921b9b42516:/usr/local/tomcat# ls -l webapps
total 20
drwxr-xr-x.  3 root root 4096 May 16 16:34 ROOT
drwxr-xr-x. 16 root root 4096 May 16 16:34 docs
drwxr-xr-x.  6 root root 4096 May 16 16:34 examples
drwxr-xr-x.  5 root root 4096 May 16 16:34 host-manager
drwxr-xr-x.  5 root root 4096 May 16 16:34 manager
root@8921b9b42516:/usr/local/tomcat# 
root@8921b9b42516:/usr/local/tomcat# exit
exit
[root@pc-openeuler-1 ~]# 
```

```
[root@pc-openeuler-1 ~]# cd software/
[root@pc-openeuler-1 software]# ls
docs  examples host-manager  manager  ROOT
[root@pc-openeuler-1 software]#
```

浏览器访问http://ip:port![](https://mmbiz.qpic.cn/mmbiz_png/WdQ2KQEQQxjhTzeicO2kb7ZP2c7oUzPwjpU98TnsPRmibrHgEAaSh4LjEb6gKWrtbRgfWtUMA1CX8JQYHMNeKbrw/640?wx_fmt=png)

这就通了

总体来说还是可以跑通的。

* * *

**=END=**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMatRzJgDKxzkb8gsqm9MstYn8W6fMhbPtZKBZFQM7j9KhZ9R0HcHFftFOibVjmusW1797xCFSUD0nw/640?wx_fmt=png)

**openEuler —— 最具活力的开源社区**

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMaRxOeek40gFtDaCe6MiaZtib6LzaoW0UAbwDfDZnRqfVaUKvExibDZodj3nAof4SZ2xZjDnpGoJEH7g/640?wx_fmt=png)
