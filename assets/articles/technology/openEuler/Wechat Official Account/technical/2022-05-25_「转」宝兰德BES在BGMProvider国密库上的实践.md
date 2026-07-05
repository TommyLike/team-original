# [「转」宝兰德BES在BGMProvider国密库上的实践](https://mp.weixin.qq.com/s/N7xUaW58ollFtFqe04Qv-g)

*宝兰德-李兵*[OpenAtom openEuler](javascript:void%280%29;)*2022-05-25 11:03:34*

> 编者按：本文主要介绍毕昇JDK BGMProvider（GMTLS Java版本实现）、国密协议、宝兰德BES中间件通过BGMProvider国密库实现国密通信相关知识和一些实践。

## 背景知识

### BGMProvider

BGMProvider是毕昇JDK团队在OpenEuler开源社区下的一个开源项目，开源地址：https://gitee.com/openeuler/BGMProvider ，BGMProvider是为了在JDK原有的TLS加密通信中支持国密TLS而开发的项目, 目标是提供一个完整的GMTLS JAVA实现，主要有以下特性：

1. 支持国密标准中特有的SM2非对称加密算法/SM3密码杂凑算法/SM4对称加密算法，国密SSLSocket/SSLEngine中的握手协议以及加密通信流程
2. 基于 Java Cryptography Architecture(JCA) 框架， 提供一个JCE provider\[1]和 JSSE provider\[2]
   
   jce架构如下：
   
   ![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0H9dntoBXmwfz1vnsPrEHGdxYAL1FibWcE1XSl1Jpjr6PeG20Jy6EIfKg/640?wx_fmt=png)
   
   jsse架构如下：
   
   ![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HwOJOEtiadF1ia3MytREbSZ8YsWdeVbQtrdB8uKWicKFQSibADWcPEdKtvA/640?wx_fmt=png)
3. 支持的中间件  
   Tomcat: 8.5.2及以上，9.0.1及以上，10.0.0及以上  
   Spring boot: 2.5.8及以上  
   Netty: 4.1.7.1.Final及以上  
   BES: 9.5及以上版本
4. 版本节奏  
   每个季度一个版本，即3.30、6.30、9.30、12.30（中间可能会出临时版本）

### 宝兰德BES

宝兰德BES应用服务器是一款JavaEE应用服务器，支持最新的JavaEE规范标准，如EJB3.2、Servlet3.1、JSP 2.3、JSTL 1.2、JSF 2.2、JavaMail 1.5、JMS 2.0等。从大的功能来讲BES应用服务器功能主要包括：

> 1. 卓越的Web、EJB和JMS。
> 2. 集中的中央全系统可视化管理。
> 3. 方便实用的日志查看和功能模块监控。

### 国密算法

国密算法指的是**SM2/SM3/SM4**等算法，其中“SM”代表“商密”，即用于商用的、不涉及国家秘密的密码技术。

- SM2为基于椭圆曲线密码的公钥密码算法标准，包含数字签名、密钥交换和公钥加密，用于替换RSA/Diffie-Hellman/ECDSA/ECDH等国际算法;
- SM3\[3]为密码哈希算法，用于替代MD5/SHA-1/SHA-256等国际算法；
- SM4为分组密码，用于替代DES/AES等国际算法；

### 国密证书

国密证书是使用国密算法进行公钥签名和HASH运算，并采用国密密钥封装的证书。国密证书同样符合X.509等国际标准证书规范。在国内很多政企应用场景中，经常会使用“双国密证书”架构，即每个服务同时部署两套证书：签名证书和加密证书。签名证书代表该节点身份，用于身份认证和对数据签名；加密证书用于交换密钥和对数据加密。

### 国密SSL协议

国密SSL协议是符合国密标准*GM/T0024-2014*\[4]和*GB/T38636-2020*\[5]的安全传输协议，类似于国际SSL/TLS，国密SSL协议实际落地，需要国密证书、国密Web服务器、国密浏览器等互相配合。

### 标准SSL与国密SSL自适应

国密SSL可同时兼容标准SSL，在同一个服务端口中，自适应来自不同客户端标准SSL通信和国密SSL通信，解决从标准SSL到国密SSL的平滑过度。

下面主要介绍宝兰德BES应用服务器如何通过毕昇JDK的BGMProvider来实现web服务的国密SSL通信。

## BGMProvider基本使用

### maven下载安装

可以通过maven坐标直接依赖编译好的库,目前最新版本是1.0.3.2：

```
<dependency>
    <groupId>org.openeuler</groupId>
    <artifactId>bgmProvider</artifactId>
    <version>1.0.3.2</version>
</dependency>
```

### 源码编译安装

编译要求: JDK8u302+, JDK11.0.11+，执行下面命令即可:

```
$ git clone https://gitee.com/openeuler/BGMProvider.git
$ cd BGMProvider
$ mvn package
```

编译完成之后，目录结构如下：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HYURjNQh4OFNXAurZXxslpiaqQ37ibibXPiaKYXIoTskiaS07OTvK6Taic6lg/640?wx_fmt=png)

- bgmprovider模块
  
  将jca和jsse注册的算法组合成BGMProvider，在使用GMTLS时，只需要配置BGMProvider即可
- jca模块
  
  支持国密标准中特有的SM2非对称加密算法/SM3密码杂凑算法/SM4对称加密算法
- jsse模块
  
  支持国密SSLSocket/SSLEngine中的握手协议以及加密通信流程
- tomcat-adaptor模块
  
  用于在Tomcat中支持国密TLS

将target目录下的jsse-xxxx.jar, jca-xxxx.jar, bgmprovider-xxxx.jar三个jar包(或bgmprovider-xxxx-jar-with-dependencies.jar一个jar包)拷贝至CLASSPATH目录即可。如果在tomcat中使用，则还需要将tomcat-adaptor-xxxx.jar拷贝至$TOMCAT\_HOME/lib。

### 配置方式

方式一：修改JDK配置文件，直接集成到JDK当中

修改path\_to\_jre/lib/security/java.security文件，添加BGMProvider。

```
security.provider.1=org.openeuler.BGMProvider
security.provider.2=sun.security.provider.Sun
security.provider.3=sun.security.rsa.SunRsaSign
security.provider.4=sun.security.ec.SunEC
security.provider.5=com.sun.net.ssl.internal.ssl.Provider
security.provider.6=...
...
```

方式二: 使用Security API 添加BGMProvider ，并设置其优先级。

例：设置BGMProvider为最高优先级

```
Security.insertProviderAt(new BGMProvider(), 1);
```

### 使用国密算法

下面案例使用SM3算法计算字符串摘要信息：

```
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.Security;

public class SM3Test {
    private static String plainText = "hello sm3";

    public static void main(String[] args) throws Exception {
        // 使用Security API 添加BGMProvider
        //Security.insertProviderAt(new org.openeuler.BGMJCEProvider(), 1);
        MessageDigest md = MessageDigest.getInstance("SM3");
        md.update(plainText.getBytes(StandardCharsets.UTF_8));
        byte[] res = md.digest();
        System.out.println(new String(res));
    }
}
```

如没有使用BGMProvider，执行上述代码会出现如下SM3算法无法找到的异常：

```
Exception in thread "main" java.security.NoSuchAlgorithmException: SM3 MessageDigest not available
        at sun.security.jca.GetInstance.getInstance(GetInstance.java:159)
        at java.security.Security.getImpl(Security.java:697)
        at java.security.MessageDigest.getInstance(MessageDigest.java:170)
        at com.bes.enterprise.gmssl.adaptor.SM3Test.main(SM3Test.java:12)
```

## BES中使用BGMProvider开启GMTLS

### 国密证书

根据国密标准，GMTLS是双证书体系，且必须使用国密算法，正式的网站可以通过*cfca*\[6]官网去申请国密证书，为了测试，我们可以通过keytool工具生成国密证书(需要在JDK中配置国密库，可参考BGMProvider的配置方式\[7])，具体生成过程如下：

```
############# CA根证书制作 #############
# 生成CA密钥
keytool -genkey -keyalg SM2 -sigalg SM3withSM2  -keysize 256 -ext KeyUsage=DigitalSignature,nonRepudiation,keyCertSign,crlSign -ext BasicConstraints=CA:true -keystore server-rootca.p12 -storepass changeit -keypass changeit -storetype pkcs12 -alias server-rootca -dname "CN=server-rootca" -validity 3650 -storetype pkcs12

# 导出CA根证书
keytool -exportcert -keystore server-rootca.p12 -alias server-rootca -file server-rootca.crt -storepass changeit -trustcacerts -storetype pkcs12

# 导入CA根证书到%JAVA_HOME%/jre/lib/security/cacerts信任库
keytool -import -alias server-rootca -file server-rootca.crt -keystore  %JAVA_HOME%/jre/lib/security/cacerts -storepass changeit -trustcacerts -noprompt

############# SM2签名证书制作 #############

# 生成SM2签名密钥
keytool -genkey -keyalg SM2 -sigalg SM3withSM2  -keysize 256 -ext KeyUsage=digitalSignature  -ext SubjectAlternativeName=dns:localhost,ip:127.0.0.1  -keystore server-sm2.p12 -storepass changeit -keypass changeit -storetype pkcs12 -alias server-sm2-sig -dname "CN=server/sm2/sig" -validity 3650  -storetype pkcs12

# 生成SM2签名证书请求
keytool -certreq -alias server-sm2-sig -sigAlg SM3withSM2 -keystore server-sm2.p12 -file server-sm2-sig.csr -storepass changeit  -storetype pkcs12

# 使用CA根证书制作SM2签名证书
keytool -gencert -ext KeyUsage=digitalSignature  -ext SubjectAlternativeName=dns:localhost,ip:127.0.0.1   -sigalg SM3withSM2 -alias server-rootca -keystore server-rootca.p12 -infile server-sm2-sig.csr -outfile server-sm2-sig.crt -storepass changeit -validity 3650  -storetype pkcs12

# 将SM2签名证书导入密钥库
keytool -import -alias server-sm2-sig -file server-sm2-sig.crt -keystore server-sm2.p12 -trustcacerts -storepass changeit -trustcacerts -storetype pkcs12

############# SM2加密证书制作 #############
# 生成SM2加密密钥
keytool -genkey -keyalg SM2 -sigalg SM3withSM2  -keysize 256 -ext KeyUsage=keyEncipherment,dataEncipherment,keyAgreement  -ext SubjectAlternativeName=dns:localhost,ip:127.0.0.1  -keystore server-sm2.p12 -storepass changeit -keypass changeit -storetype pkcs12 -alias server-sm2-enc -dname "CN=server/sm2/enc" -validity 3650 -storetype pkcs12

# 生成SM2加密证书请求
keytool -certreq -alias server-sm2-enc -sigAlg SM3withSM2 -keystore server-sm2.p12 -file server-sm2-enc.csr -storepass changeit -storetype pkcs12

# 使用CA根证书制作SM2加密证书
keytool -gencert -ext KeyUsage=keyEncipherment,dataEncipherment,keyAgreement  -ext SubjectAlternativeName=dns:localhost,ip:127.0.0.1  -sigalg SM3withSM2  -alias server-rootca -keystore server-rootca.p12 -infile server-sm2-enc.csr -outfile server-sm2-enc.crt -storepass changeit -validity 3650 -storetype pkcs12

# 将SM2加密证书导入密钥库
keytool -import -alias server-sm2-enc -file server-sm2-enc.crt -keystore server-sm2.p12  -trustcacerts -storepass changeit -trustcacerts -storetype pkcs12
```

证书制作完成之后，我们只需要用到server-sm2.p12这一个密钥库即可。

### BES上配置GMTLS

#### BES安装和启动

这里我们选择毕昇JDK8u302和BES9.5版本，以下是一些简单的安装和启动过程：

- 毕昇JDK安装

```
# 下载毕昇JDK,选择对应的平台，版本8u302+
cd /opt/java/
wget https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_jdk/bisheng-jdk-8u302-linux-x64.tar.gz
# 解压安装
tar -zxvf bisheng-jdk-8u302-linux-x64.tar.gz
# 配置环境变量JAVA_HOME，指向JDK解压路径
export JAVA_HOME=/opt/java/bisheng-jdk1.8.0_302
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
# 验证JDK安装，执行如下命令显示对应JDK版本信息即安装完成
java -version
```

- BES安装

```
# 创建BES安装目录
mkdir BES9.5
tar -zxvf BES-AppServer-Standard-9.5xxxx.tar.gz -C BES9.5
```

为了集成BGMProvider支持GMTLS，需要将BGMProvider库和国密证书放入安装目录，如下

1. 将bgmprovider-xxxx-jar-with-dependencies.jar拷贝至BES9.5/lib目录下
2. 将server-sm2.p12证书文件放入BES9.5/conf/security目录

完成之后可以启动BES应用服务器：

```
cd BES9.5/bin
./iastool --passwordfile ../conf/.passwordfile --user admin start --server
```

启动完成之后，可通过浏览器访问BES管理控制台，地址http://localhost:1900/console/，使用默认账号登录。

#### 配置GMTLS

为了能通过浏览器直接访问国密SSL协议的应用，此处我们单独创建http监听器，首先点击左侧**HTTP监听器**菜单，可以看到默认的四个监听器：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HvfgDzSEpxWRBc3RaVYlyl5FmrxtqtPVmicJF61ib7cJmheIrwOnrTv8g/640?wx_fmt=png)

新创建监听器http-listener-3，指定端口为8445，开启安全性和国密通道：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HQ8oG9f9t2YzayYx6jfRauy4viaiccH3GxFvkStdKzlJupRpmEfMlY17A/640?wx_fmt=png)

在国密通道页面中指定以下参数：

- GMTLS协议
- 证书昵称：server-sm2-sig,server-sm2-enc
  
  需要填写签名证书昵称和加密证书昵称，签名证书昵称在前，加密证书昵称在后，以英文逗号分隔
- 签名证书和加密证书密钥库路径：{com.bes.instanceRoot}/conf/security/server-sm2.p12
  
  需要填写签名证书和加密证书密钥库路径，同样签名证书在前，加密证书在后，指定前文我们创建的国密证书server-sm2.p12，以英文逗号分隔，此处我们使用的同一个证书库，实际也可以使用不同的证书库。
- 密钥密码: changeit,changeit
  
  需要填写加密证书密钥密码和签名证书密钥密码，以英文逗号分隔，此处填写我们在前文创建证书中指定的密钥密码
- 密钥库密码: changeit,changeit
  
  需要填写加密证书密钥库密码和签名证书密钥库密码，以英文逗号分隔，此处填写我们在前文创建证书中指定的密钥库密码
- 密钥库类型: PKCS12,PKCS12
  
  需要填写加密证书密钥库类型和签名证书密钥库类型，以英文逗号分隔，此处填写我们在前文创建证书中指定的密钥库类型
- 密码套件：ECC\_SM4\_CBC\_SM3
  
  填写GMTLS中使用的密码套件，多个以英文逗号分隔，支持四种密码套件：ECC\_SM4\_CBC\_SM3,ECDHE\_SM4\_CBC\_SM3,ECC\_SM4\_GCM\_SM3,ECDHE\_SM4\_GCM\_SM3
- 提供者：BGMProvider
  
  填写GMTLS提供者，由于我们采用BGMProvider，因此此处填写BGMProvider即可

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HHfHmBiayZLYdR4SK3e0FSBXZLD7q9OjeO0ooExCWf8k382KylcMSiblw/640?wx_fmt=png)

#### 编写和部署测试应用GMDemo

这里我们编写一个简单的web测试应用部署到BES当中，一个静态页面index.html，内容如下：

```
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>

<div style="text-align:left">
<h1>Hello bgmprovider GMTLS</h1>
</div>
</body>
</html>
```

通过***应用管理***来部署应用，部署完成之后，应用列表如下：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HqvpiaepTA0WyXHlfflS8ibp8kN6vic4NdMmnREy52UFKxKILsrFS4qqOg/640?wx_fmt=png)

部署应用之后，即可重启BES使得配置生效，重启方式如下:

```
./iastool --passwordfile ../conf/.passwordfile --user admin stop --server
./iastool --passwordfile ../conf/.passwordfile --user admin start --server
```

### 测试GMTLS

在前文中已经在BES上部署了测试应用，并开启了GMTLS访问端口，现在我们选择国密浏览器来访问测试应用，这里我们选择密信浏览器，官网下载路径：

https://app.mesince.com/browser/MeSignBrowser\_setup.exe， 安装好之后，直接访问 https://localhost:8445/GMDemo/

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HHyCqYHafMM6fM2aR66gTqTM4C27uNRAuDbuibMqkbIvno3JBia6cgwpQ/640?wx_fmt=png)

可以看到使用的证书确实我们在前文中创建的SM2国密证书。

### 通过wireshark查看GMTLS握手过程

wireshark国密版本下载位置：https://github.com/pengtianabc/wireshark-gm/releases/download/wireshark-3.4.5-gm/Wireshark-win64-3.4.5.exe

通过过滤8445端口信息之后，重复上述访问步骤，可获取到如下报文：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HPFvIEic2gdSEeRWicV7HJxLWSnn55tayy3mg1oicESQl51QMw9EFk6eIg/640?wx_fmt=png)

基本符合规范中的握手过程：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HciapXeKhszp2raZwjrUxaNLQxocWOClefLNS1FqUq9UtCIWdIaApkEw/640?wx_fmt=png)

从握手协议上看，和标准TLS并无太大差别，我们继续看几个核心握手消息的内容，

Client Hello：客户端告诉服务端使用GMTLS协议、密码套件支持ECC\_SM4\_SM3(同ECC\_SM4\_CBC\_SM3)：

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0H9icribW2pEKxNw47RaNMdAAibuqic9VP6wfdbSPq6gXk8aTyZVPLNMGX3Q/640?wx_fmt=png)

Server Hello：确定密码套件选择ECC\_SM4\_SM3

Certificates：将服务端国密证书发给客户端（签名证书、加密证书、根证书）

Server Key Exchange：服务端密钥交换，细节可参考国密标准(*GM/T0024-2014*\[4]和*GB/T38636-2020*\[5])

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HBVUgSJuOeafmJAVWVPjDLLNHp7YXcZA2XAKTU5icWn9RIAoI9UHkatA/640?wx_fmt=png)

Client Key Exchange：客户端密钥交换

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HjhibYz4VAbNUlOJeEtdYwuOoPKRuzWgF1bVFwhWtFQd9zicmly5n7wkA/640?wx_fmt=png)

后续就是数据加密传输，此处不再叙述，详细可参考国密标准。从整个握手过程可判断确实已经在BES上实现GMTLS通信。

## BES中使用BGMProvider同时开启GMTLS和TLS

### BES上配置同时支持GMTLS和TLS1.2

BGMProvider可同时支持GMTLS和标准TLS，那么下面只需要稍微修改BES中http监听器的配置就能实现GMTLS和标准TLS的自适应，首先回到国密通道配置页面配置以下参数：

在国密通道页面中指定以下参数：

- GMTLS协议、TLS1.2协议
  
  增加标准TLS1.2协议支持\[8]
- 证书昵称：server-sm2-sig,server-sm2-enc,bes
  
  增加BES自带的rsa证书昵称
- 签名证书和加密证书密钥库路径:{com.bes.instanceRoot}/conf/security/server-sm2.p12,${com.bes.instanceRoot}/conf/security/keystore.jks
  
  增加BES自带的rsa密钥库路径
- 密钥密码: changeit,changeit,changeit
  
  增加BES自带的rsa密钥密码
- 密钥库密码: changeit,changeit,changeit
  
  增加BES自带的rsa密钥库密码
- 密钥库类型: PKCS12,PKCS12,JKS
  
  增加BES自带的rsa密钥库类型
- 密码套件：ECC\_SM4\_CBC\_SM3,TLS\_ECDHE\_RSA\_WITH\_AES\_128\_GCM\_SHA256
  
  增加TLS1.2密码套件
- 提供者：BGMProvider
  
  保持不变

![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HVfWs84jEJmtbOokaVG0ibxL0VYuq9ibf7a3CFfsOCsAdlUcNL2ShKNBA/640?wx_fmt=png)

### 多客户端访问测试应用

- 使用密信浏览器访问，结果和之前访问结果是一致的
- 使用普通非国密浏览器访问结果，使用的是标准TLS1.2协议和我们配置的TLS\_ECDHE\_RSA\_WITH\_AES\_128\_GCM\_SHA256密码套件
  
  ![](https://mmbiz.qpic.cn/mmbiz_png/icntuIQtpSJVYV1W7AuLXsRibQnBAZnf0HLvbtVWyc7D412hE0Z10xdUNpNnU9Mf5c2PKiaKZUqOiaP7FyYOicic8pbQ/640?wx_fmt=png)
  
  从测试结果来看，已经支持标准SSL和GMSSL自适应。

## 总结

经过上面的测试，毕昇JDK的BGMProvider国密库在不做修改的情况下完全可以集成到BES应用服务器当中，作为GMTLS的引擎，且基本功能测试正常，后续还可以测试其他密码套件以及性能测试等，除了web应用，在普通java应用中也可以尝试使用BGMProvider作为国密库使用。以上如有错误的地方，欢迎指正。

## 参考

1. https://docs.oracle.com/javase/8/docs/technotes/guides/security/crypto/CryptoSpec.html
2. https://docs.oracle.com/javase/8/docs/technotes/guides/security/jsse/JSSERefGuide.html#Introduction
3. http://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=45B1A67F20F3BF339211C391E9278F5E
4. http://www.gmbz.org.cn/main/viewfile/20180110021416665180.html
5. http://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=778097598DA2761E94A5FF3F77BD66DA
6. http://www.cfca.com.cn
7. https://gitee.com/openeuler/BGMProvider/wikis/%E4%B8%AD%E6%96%87%E6%96%87%E6%A1%A3/BGMProvider%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97
8. https://datatracker.ietf.org/doc/html/rfc5246

## 后记

如果遇到相关技术问题（包括不限于毕昇 JDK），可以通过 Compiler SIG 求助。Compiler SIG 每双周周二举行技术例会，同时有一个技术交流群讨论 GCC、LLVM 和 JDK 等相关编译技术，感兴趣的同学可以添加如下微信小助手入群。

![](https://mmbiz.qpic.cn/mmbiz_jpg/icntuIQtpSJURabyabXmK64ich3UzDtIyn2picNDbEMLvAMkuCFsnz8oVXYibnZXWVRJy8SwHIsh4YW629PMgeicymg/640?wx_fmt=jpeg)

* * *

关注 **毕昇编译** 获取编译技术更多信息

点击 **阅读原文** 开始使用毕昇 JDK

[阅读原文](https://www.hikunpeng.com/zh/developer/devkit/compiler/jdk)
