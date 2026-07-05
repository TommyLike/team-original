# [从零开始在openEuler上构建Hadoop](https://mp.weixin.qq.com/s/R-hfF1bxv28Wl9FDkfTySw)

原创*hubble*[OpenAtom openEuler](javascript:void%280%29;)*2021-01-12 12:00:00*

# 0. 申请环境

可以从PCL上申请，申请流程如下：  
https://openeuler.org/zh/blog/fred\_li/2020-03-25-apply-for-vm-from-pcl.html  
申请完环境后就可以通过terminal登录辣~(xshell, mobaXterm, putty, 选一个你喜欢的)

## 1. 配置yum源

```
vi /etc/yum.repos.d/openEuler_aarch64.repo

# 在文件中添加如下openEuler社区的yum源
[openEuler]
name=openEuler
baseurl=https://repo.openeuler.org/openEuler-20.03-LTS/everything/aarch64/
enabled=1
gpgcheck=0
```

## 2. 安装依赖

```
yum install docker -y
yum install java -y
yum install java-devel -y
yum install make -y
yum install autoconf -y
yum install automake -y
yum install gcc -y
yum install gcc-c++ -y
```

```
# 查看java安装路径
[root@node2 ~]# alternatives --config java

There is 1 program that provides 'java'.

  Selection    Command
-----------------------------------------------
*+ 1           java-1.8.0-openjdk.aarch64 (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-1.h5.oe1.aarch64/jre/bin/java)


vi ~/.bashrc
# 配置PATH，添加JAVA_HOME路径
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-1.h5.oe1.aarch64
export PATH=$PATH:$JAVA_HOME/bin

# source执行下使环境变量生效
source ~/.bashrc
```

## 3. 安装maven

这里我们使用maven 3.6.3

```
# 下载maven
cd /opt
wget https://apache.website-solution.net/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -zxvf apache-maven-3.6.3-bin.tar.gz
```

```
# 配置PATH，添加maven路径
vi ~/.bashrc

export MAVEN_HOME=/opt/apache-maven-3.6.3
export PATH=$PATH:$MAVEN_HOME/bin

# source执行下使环境变量生效
source ~/.bashrc
```

```
# 修改使用aliyun的maven源
cd /opt/apache-maven-3.6.3
vim conf/settings.xml
```

```
    <!-- 在mirrors标签下添加-->
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
```

```
# 确认maven安装成功
[root@node1 ~]# mvn --version
Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
Maven home: /opt/apache-maven-3.6.3
Java version: 1.8.0_242, vendor: Huawei Technologies Co., Ltd, runtime: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-1.h5.oe1.aarch64/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "4.19.90-2003.4.0.0036.oe1.aarch64", arch: "aarch64", family: "unix"

```

## 4. 安装protobuf-2.5.0

hadoop构建依赖protobuf-2.5.0，但是protobuf官方并没有release aarch64的版本，所以我们就自己编一个吧^\_^

### i. 下载protobuf

```
wget https://github.com/protocolbuffers/protobuf/archive/v2.5.0.tar.gz
tar -zxvf v2.5.0.tar.gz
```

### ii. 下载protobuf-2.5.0-arm64-patch

由于protobuf2.5.0社区版本是不支持arm64架构的，所以我们需要打上一个支持arm64编译的patch，patch获取地址如下：  
https://gist.github.com/liusheng/64aee1b27de037f8b9ccf1873b82c413#file-protobuf-2-5-0-arm64-patch

感谢 liusheng 同学提供的protobuf-2.5.0-arm64.patch  
可以将这个文件内容copy下  
然后本地新建protobuf-2.5.0-arm64.patch文件存储

```
mv protobuf-2.5.0-arm64.path protobuf-2.5.0
cd protobuf-2.5.0
git apply protobuf-2.5.0-arm64.path
cd ..
```

### iii. 下载gtest依赖

因为墙的原因T\_T，我们直接执行protobuf的autogen.sh会因为下载googletest超时而失败，所以要手动下载googletest，并重命名为gtest，放在protobuf-2.5.0目录下

```
wget https://github.com/google/googletest/archive/release-1.5.0.tar.gz
tar -zxvf release-1.5.0.tar.gz
mv googletest-release-1.5.0 gtest
mv gtest/ protobuf-2.5.0
```

### iv. 编译protobuf

```
cd protobuf-2.5.0
./autogen.sh
./configure --prefix=/usr/local/protobuf
make -j
make install

vi ~/.bashrc
# 配置protoc路径
export PROTOC_HOME=/usr/local/protobuf
export PATH=$PATH:$PROTOC_HOME/bin

# source执行下使环境变量生效
source ~/.bashrc
```

验证protoc是否安装成功

```
[root@node1 protobuf-2.5.0]# protoc --version
libprotoc 2.5.0
```

## 5. 编译hadoop

千呼万唤始出来，依赖搞完了，终于等到我们的主角出场了~

```
# 下载hadoop代码
# 如果觉得慢，可以通过gitee fork一个hadoop的仓，从gitee下载
git clone https://github.com/apache/hadoop.git
cd hadoop

# 切换到trunk分支
git checkout -b trunk origin/trunk
```

为了提高编译的速度，作者使用了maven多线程构建，嘿嘿

```
mvn clean package -DskipTests -Dmaven.compile.fork=true -T 1C
```

## 6. 最终结果

```
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for Apache Hadoop Main 3.4.0-SNAPSHOT:
[INFO]
[INFO] Apache Hadoop Main ................................. SUCCESS [  2.287 s]
[INFO] Apache Hadoop Build Tools .......................... SUCCESS [ 12.014 s]
[INFO] Apache Hadoop Project POM .......................... SUCCESS [  0.738 s]
[INFO] Apache Hadoop Annotations .......................... SUCCESS [  1.431 s]
[INFO] Apache Hadoop Project Dist POM ..................... SUCCESS [  0.069 s]
[INFO] Apache Hadoop Assemblies ........................... SUCCESS [  0.944 s]
[INFO] Apache Hadoop Maven Plugins ........................ SUCCESS [  3.429 s]
[INFO] Apache Hadoop MiniKDC .............................. SUCCESS [  1.549 s]
[INFO] Apache Hadoop Auth ................................. SUCCESS [  3.996 s]
[INFO] Apache Hadoop Auth Examples ........................ SUCCESS [  1.425 s]
[INFO] Apache Hadoop Common ............................... SUCCESS [ 25.019 s]
[INFO] Apache Hadoop NFS .................................. SUCCESS [  1.716 s]
[INFO] Apache Hadoop KMS .................................. SUCCESS [  2.040 s]
[INFO] Apache Hadoop Registry ............................. SUCCESS [  1.770 s]
[INFO] Apache Hadoop Common Project ....................... SUCCESS [  0.301 s]
[INFO] Apache Hadoop HDFS Client .......................... SUCCESS [ 18.989 s]
[INFO] Apache Hadoop HDFS ................................. SUCCESS [ 43.331 s]
[INFO] Apache Hadoop HDFS Native Client ................... SUCCESS [  0.406 s]
[INFO] Apache Hadoop HttpFS ............................... SUCCESS [  2.907 s]
[INFO] Apache Hadoop HDFS-NFS ............................. SUCCESS [  1.867 s]
[INFO] Apache Hadoop HDFS-RBF ............................. SUCCESS [  6.558 s]
[INFO] Apache Hadoop HDFS Project ......................... SUCCESS [  0.216 s]
[INFO] Apache Hadoop YARN ................................. SUCCESS [  0.213 s]
[INFO] Apache Hadoop YARN API ............................. SUCCESS [ 13.675 s]
[INFO] Apache Hadoop YARN Common .......................... SUCCESS [ 10.770 s]
[INFO] Apache Hadoop YARN Server .......................... SUCCESS [  0.227 s]
[INFO] Apache Hadoop YARN Server Common ................... SUCCESS [  5.707 s]
[INFO] Apache Hadoop YARN NodeManager ..................... SUCCESS [ 10.031 s]
[INFO] Apache Hadoop YARN Web Proxy ....................... SUCCESS [  1.226 s]
[INFO] Apache Hadoop YARN ApplicationHistoryService ....... SUCCESS [  2.350 s]
[INFO] Apache Hadoop YARN Timeline Service ................ SUCCESS [  1.174 s]
[INFO] Apache Hadoop YARN ResourceManager ................. SUCCESS [ 26.316 s]
[INFO] Apache Hadoop YARN Server Tests .................... SUCCESS [  1.633 s]
[INFO] Apache Hadoop YARN Client .......................... SUCCESS [  2.856 s]
[INFO] Apache Hadoop YARN SharedCacheManager .............. SUCCESS [  0.954 s]
[INFO] Apache Hadoop YARN Timeline Plugin Storage ......... SUCCESS [  1.141 s]
[INFO] Apache Hadoop YARN TimelineService HBase Backend ... SUCCESS [  0.452 s]
[INFO] Apache Hadoop YARN TimelineService HBase Common .... SUCCESS [  2.909 s]
[INFO] Apache Hadoop YARN TimelineService HBase Client .... SUCCESS [  3.058 s]
[INFO] Apache Hadoop YARN TimelineService HBase Servers ... SUCCESS [  0.059 s]
[INFO] Apache Hadoop YARN TimelineService HBase Server 1.2  SUCCESS [  2.303 s]
[INFO] Apache Hadoop YARN TimelineService HBase tests ..... SUCCESS [  3.025 s]
[INFO] Apache Hadoop YARN Router .......................... SUCCESS [  1.510 s]
[INFO] Apache Hadoop YARN TimelineService DocumentStore ... SUCCESS [  2.190 s]
[INFO] Apache Hadoop YARN Applications .................... SUCCESS [  0.149 s]
[INFO] Apache Hadoop YARN DistributedShell ................ SUCCESS [  1.201 s]
[INFO] Apache Hadoop YARN Unmanaged Am Launcher ........... SUCCESS [  0.859 s]
[INFO] Apache Hadoop MapReduce Client ..................... SUCCESS [  1.239 s]
[INFO] Apache Hadoop MapReduce Core ....................... SUCCESS [  4.548 s]
[INFO] Apache Hadoop MapReduce Common ..................... SUCCESS [  3.066 s]
[INFO] Apache Hadoop MapReduce Shuffle .................... SUCCESS [  1.883 s]
[INFO] Apache Hadoop MapReduce App ........................ SUCCESS [  3.893 s]
[INFO] Apache Hadoop MapReduce HistoryServer .............. SUCCESS [  5.519 s]
[INFO] Apache Hadoop MapReduce JobClient .................. SUCCESS [  4.458 s]
[INFO] Apache Hadoop Mini-Cluster ......................... SUCCESS [  1.027 s]
[INFO] Apache Hadoop YARN Services ........................ SUCCESS [  0.187 s]
[INFO] Apache Hadoop YARN Services Core ................... SUCCESS [  5.111 s]
[INFO] Apache Hadoop YARN Services API .................... SUCCESS [  2.371 s]
[INFO] Apache Hadoop YARN Application Catalog ............. SUCCESS [  0.187 s]
[INFO] Apache Hadoop YARN Application Catalog Webapp ...... SUCCESS [ 24.807 s]
[INFO] Apache Hadoop YARN Application Catalog Docker Image  SUCCESS [  0.154 s]
[INFO] Apache Hadoop YARN Application MaWo ................ SUCCESS [  0.185 s]
[INFO] Apache Hadoop YARN Application MaWo Core ........... SUCCESS [  1.838 s]
[INFO] Apache Hadoop YARN Site ............................ SUCCESS [  0.149 s]
[INFO] Apache Hadoop YARN Registry ........................ SUCCESS [  0.451 s]
[INFO] Apache Hadoop YARN UI .............................. SUCCESS [  0.147 s]
[INFO] Apache Hadoop YARN CSI ............................. SUCCESS [  4.693 s]
[INFO] Apache Hadoop YARN Project ......................... SUCCESS [  0.923 s]
[INFO] Apache Hadoop MapReduce HistoryServer Plugins ...... SUCCESS [  0.745 s]
[INFO] Apache Hadoop MapReduce NativeTask ................. SUCCESS [  1.192 s]
[INFO] Apache Hadoop MapReduce Uploader ................... SUCCESS [  0.890 s]
[INFO] Apache Hadoop MapReduce Examples ................... SUCCESS [  1.576 s]
[INFO] Apache Hadoop MapReduce ............................ SUCCESS [  1.295 s]
[INFO] Apache Hadoop MapReduce Streaming .................. SUCCESS [  1.645 s]
[INFO] Apache Hadoop Distributed Copy ..................... SUCCESS [  4.990 s]
[INFO] Apache Hadoop Federation Balance ................... SUCCESS [  3.003 s]
[INFO] Apache Hadoop Client Aggregator .................... SUCCESS [  0.915 s]
[INFO] Apache Hadoop Dynamometer Workload Simulator ....... SUCCESS [  2.477 s]
[INFO] Apache Hadoop Dynamometer Cluster Simulator ........ SUCCESS [  1.387 s]
[INFO] Apache Hadoop Dynamometer Block Listing Generator .. SUCCESS [  2.461 s]
[INFO] Apache Hadoop Dynamometer Dist ..................... SUCCESS [  1.182 s]
[INFO] Apache Hadoop Dynamometer .......................... SUCCESS [  0.204 s]
[INFO] Apache Hadoop Archives ............................. SUCCESS [  1.072 s]
[INFO] Apache Hadoop Archive Logs ......................... SUCCESS [  2.079 s]
[INFO] Apache Hadoop Rumen ................................ SUCCESS [  1.583 s]
[INFO] Apache Hadoop Gridmix .............................. SUCCESS [  3.506 s]
[INFO] Apache Hadoop Data Join ............................ SUCCESS [  1.261 s]
[INFO] Apache Hadoop Extras ............................... SUCCESS [  1.168 s]
[INFO] Apache Hadoop Pipes ................................ SUCCESS [  0.354 s]
[INFO] Apache Hadoop OpenStack support .................... SUCCESS [  1.456 s]
[INFO] Apache Hadoop Amazon Web Services support .......... SUCCESS [ 13.761 s]
[INFO] Apache Hadoop Kafka Library support ................ SUCCESS [  1.512 s]
[INFO] Apache Hadoop Azure support ........................ SUCCESS [  5.783 s]
[INFO] Apache Hadoop Aliyun OSS support ................... SUCCESS [  2.532 s]
[INFO] Apache Hadoop Scheduler Load Simulator ............. SUCCESS [  2.588 s]
[INFO] Apache Hadoop Resource Estimator Service ........... SUCCESS [  1.088 s]
[INFO] Apache Hadoop Azure Data Lake support .............. SUCCESS [  2.035 s]
[INFO] Apache Hadoop Image Generation Tool ................ SUCCESS [  2.154 s]
[INFO] Apache Hadoop Tools Dist ........................... SUCCESS [  3.231 s]
[INFO] Apache Hadoop Tools ................................ SUCCESS [  0.134 s]
[INFO] Apache Hadoop Client API ........................... SUCCESS [01:54 min]
[INFO] Apache Hadoop Client Runtime ....................... SUCCESS [01:55 min]
[INFO] Apache Hadoop Client Packaging Invariants .......... SUCCESS [  0.678 s]
[INFO] Apache Hadoop Client Test Minicluster .............. SUCCESS [03:46 min]
[INFO] Apache Hadoop Client Packaging Invariants for Test . SUCCESS [  0.321 s]
[INFO] Apache Hadoop Client Packaging Integration Tests ... SUCCESS [  0.289 s]
[INFO] Apache Hadoop Distribution ......................... SUCCESS [  0.492 s]
[INFO] Apache Hadoop Client Modules ....................... SUCCESS [  0.354 s]
[INFO] Apache Hadoop Tencent COS Support .................. SUCCESS [  2.132 s]
[INFO] Apache Hadoop Cloud Storage ........................ SUCCESS [  3.270 s]
[INFO] Apache Hadoop Cloud Storage Project ................ SUCCESS [  0.269 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  10:22 min (Wall Clock)
[INFO] Finished at: 2020-12-14T01:49:16Z
[INFO] ------------------------------------------------------------------------
[root@node1 upstream_hadoop]#
[root@node1 upstream_hadoop]#
[root@node1 upstream_hadoop]# uname -a
Linux node1 4.19.90-2003.4.0.0036.oe1.aarch64 #1 SMP Mon Mar 23 19:06:43 UTC 2020 aarch64 aarch64 aarch64 GNU/Linux

```

至此终于完成了在openEuler aarch64环境上进行apache hadoop构建

## 7. END

欢迎大家加入openEuler sig-ai-bigdata  
openEuler sig-ai-bigdata对所有开发者open！  
对在openEuler上有任何关于AI，bigdata的疑问，都欢迎加群一起讨论。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMby1NVcCHslrh29TYhfTQaDTladj5Cs7vhXicjGYMesw7xrrDv24nvrShjltnww17td3AqEsTf8tBg/640?wx_fmt=jpeg)

添加小助手微信

回复“ai”，加入交流群
