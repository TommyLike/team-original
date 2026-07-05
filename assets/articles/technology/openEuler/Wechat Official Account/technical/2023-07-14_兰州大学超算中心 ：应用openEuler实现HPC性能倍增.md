# [兰州大学超算中心 ：应用openEuler实现HPC性能倍增](https://mp.weixin.qq.com/s/e7AubYrt93Y2KD96T4cQ1Q)

[OpenAtom openEuler](javascript:void%280%29;)*2023-07-14 18:00:00*

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMaVvrxATht93YXiaMnUt1j5UvfxNKFZ3ek7BgYgTkMuUwNL5qAxrCk891P8icxjPQiblBpltCUicG6cnA/640?wx_fmt=jpeg)

兰州大学超算中心拥有 1.2P 的高性能计算平台，为学校师生开展高水平科研提供计算支撑。针对学校拥有开展大规模分子动力学、气象学和生命科学模拟需求的群体，兰州大学超算中心团队基于华为鲲鹏全栈软硬件，移植优化生命、气象、分子动力学三大领域的 GROMACS、CP2K、NEMO 等 12 款软件。团队利用开放原子开源基金会的 openEuler 操作系统、毕昇编译器，鲲鹏开发套件中的 Hyper MPI 通信库以及 KML 数学库，提高了这些移植应用软件的计算性能，为生命、医学、气象领域鲲鹏全栈计算架构提供了高效的解决方案。

![](https://mmbiz.qpic.cn/mmbiz_jpg/A0h5yD51CMaVvrxATht93YXiaMnUt1j5Uma9Y9RYVCzOsmFXJ3JQvEQ5qS0Edllak9fHkib8mngCghIf7ZHvDM4A/640?wx_fmt=jpeg)

兰州大学超算中心团队

## 解决方案

![](https://mmbiz.qpic.cn/mmbiz_png/A0h5yD51CMZyGPvO2osZVI4iaDYyxQibpJfvbWuTe4E0ttwgjC13ckZcXdic0iaOpLezb8rnibOolTf13K9JtTQZwKQ/640?wx_fmt=png)

1. 操作系统版本：openEuler 21.03
2. 本方案分子动力学模块基于鲲鹏软硬件平台如鲲鹏 920 平台、DevKit 迁移调优套件及 openEuler 毕昇编译器等对分子动力学应用软件 GROMACS，LAMMPS，CP2K，QE 完成迁移和优化。
3. 本方案生命科学模块对生命科学学重要应用 BUSCO、Falcon、HMMER、RepeatMasker、Trimmomatic 完成从 x86 平台到鲲鹏 ARM 平台的迁移优化，获得了更好的可拓展性和计算效率的提升。
4. 本方案气象学模块结合鲲鹏 HPC +openEuler 软硬件平台对气象学重要应用 WRF、CESM、NEMO 完成迁移适配，结合鲲鹏优化技术获得更高的计算效率，相比原有 x86 平台，提供更好的计算性能。

## 客户价值

1. 实现 openEuler+鲲鹏高性能计算集群部署，助力高校科研创新及人才培养，可以为用户提供多元化算力服务。
2. 完成了 openEuler+鲲鹏架构在 HPC 气象、生命等领域的生态应用，相较于原 X86 架构计算性能有较大提升。

**用户案例征集**

![](https://mmbiz.qpic.cn/mmbiz_gif/A0h5yD51CMaVvrxATht93YXiaMnUt1j5UiatjvPRM76Gyicx80icUKe0O0Tra4F2vubX2Y07ibQP99Z7wibaTm3Yw0Jw/640?wx_fmt=gif)

openEuler用户案例持续征集中，如果您的项目有在应用openEuler操作系统或openEuler社区技术项目，欢迎联系user@openeuler.sh发布案例。

案例撰写指南：[用户案例撰写&投稿指南](http://mp.weixin.qq.com/s?__biz=MzI2NDE4OTE2Mg%3D%3D&mid=2247504655&idx=1&sn=c999745c471760b99bd601a57bc81c37&chksm=eab2f68addc57f9cc72385b4e5bdd163389368b370655a38606bfe53c3d2e7d5381debd70afc&scene=21#wechat_redirect)

点击“阅读原文”查看更多openEuler用户案例。

[阅读原文](https://www.openeuler.org/zh/showcase/)
