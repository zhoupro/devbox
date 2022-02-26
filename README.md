# vitualbox下安装ubuntu lts 20.04
## 下载ubuntu长期支持版
访问mirrors.aliyun.com 下载ubuntu长期支持版本，目前最新的版本是20.04
![从阿里云下载镜像](images/download_ubuntu_lts_from_aliyun.png)

## 安装ubuntu
### 启动界面
![启动界面](images/ubuntu_setup_1_setup_ui.png)
### 名称和存储位置
![虚拟机名称和存储位置](images/ubuntu_setup_2_os_meta.png)
### 内存
![内存](images/ubuntu_setup_3_os_memory.png)
### 硬盘
![硬盘](images/ubuntu_setup_4_os_disk.png)
### 硬盘类型
![硬盘类型](images/ubuntu_setup_5_os_disk_type.png)
### 硬盘分配方式
![硬盘分配方式](images/ubuntu_setup_6_os_disk_allocate.png)
### 硬盘大小
![硬盘大小](images/ubuntu_setup_7_os_disk_size.png)
### 基本设置完成
![基本设置完成](images/ubuntu_setup_8_setup_complete.png)
### 设置界面
![设置界面](images/ubuntu_setup_9_setting.png)
### 系统镜像位置
![系统镜像](images/ubuntu_setup_10_setting_image_location.png)
### 启动安装
![语言](images/ubuntu_setup_11_startup.png)
### 语言和安装ubuntu
![语言](images/ubuntu_setup_12_language.png)
### 键盘布局
![语言](images/ubuntu_setup_13_language.png)
### 软件
![语言](images/ubuntu_setup_14_soft.png)
### 文件系统
![语言](images/ubuntu_setup_15_disk.png)
### 时区
![语言](images/ubuntu_setup_16_zone.png)
### 用户信息
![语言](images/ubuntu_setup_17_user.png)

## 安装增强包
### 切换阿里云的apt源

```bash
sudo sed -i  's/cn.archive.ubuntu.com/mirrors.aliyun.com/g'  /etc/apt/sources.list
sudo sed -i  's/archive.ubuntu.com/mirrors.aliyun.com/g'  /etc/apt/sources.list
sudo apt update
```

### 安装扩展包依赖
```bash
sudo apt install gcc make perl 
```
### openssh

```bash
sudo apt install openssh-server
```

修改 /etc/ssh/ssh_config，使用密码验证
   PasswordAuthentication yes

### 开启切换sudo不需要密码
修改 /etc/sudoers,添加
```ini
vagrant ALL=(ALL) NOPASSWD:ALL
Defaults:vagrant !requiretty
```

### 插入扩展包
![插入扩展包](images/ubuntu_setup_18_additional.png)

### 运行安装程序
![运行安装程序](images/ubuntu_setup_19_additional_soft.png)


## 从virtual虚拟机生成vagrant box
```bash
vagrant package --base linuxmint --output linuxmint.box
```

## 添加虚拟机到vagrant

```bash
vagrant box list
```

```bash
vagrant box add linuxmint ./linuxmint.box
```

## 启动vagrant

```bash
vagrant up
```

## ssh登录
```bash
vagrant ssh kmaster
```

