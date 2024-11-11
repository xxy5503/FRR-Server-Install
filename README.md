# Ubuntu系统FRRouting安装配置

## 介绍

这个项目提供了一个安装脚本，用于在 Ubuntu 系统上安装和配置 [FRRouting](https://frrouting.org/)（`frr`）。该脚本将自动安装 FRRouting 所需的依赖包、启用 FRRouting 服务，以便在命令行工具中方便地进行路由配置。

该版本的脚本已针对Ubuntu系统进行优化，方便部署。

## 特性

- 自动安装 FRRouting 和相关依赖。
- 配置并启用所有 FRRouting 服务。
- Linux shell中通过 `enable`命令进入命令行模式。

## 先决条件

- 确认部署的主机可以连网。
- 需要在目标系统上执行一键安装脚本。

## 安装和使用

### 1. 下载自动安装脚本文件

首先，下载安装脚本。

```bash
#下载之前，请确认服务器已经安装git
git clone https://github.com/xxy5503/FRR-Server-Install.git
cd FRR-Server-Install
```

```bash
# 下载后，确保它具有执行权限
chmod +x install-frr
```

### 2. 执行自动安装脚本

使用以下命令执行该文件：

```bash
sudo ./install-frr
```

- 请确保你使用 `sudo` 运行该二进制文件，因为它需要管理员权限来安装软件和修改系统配置。
- 执行时，脚本将自动：
  - 添加 FRRouting 仓库。
  - 安装 FRRouting 和相关依赖。
  - 修改配置文件，启用所有 FRRouting 服务。

### 3. 配置验证

执行脚本后，系统会自动重启 FRRouting 服务以使配置生效。你可以通过以下命令验证安装和配置是否成功：

```bash
# 确认 FRRouting 是否正在运行
sudo systemctl status frr

# 确认 'enable' 命令是否可用
enable
```

如果一切正常，执行 `enable` 后应该会进入 FRR` 命令行界面。

### 4. 退出 `FRR`

在 `frr shell` 中，你可以执行各种路由配置命令。要退出 `frr shell`，请输入：

```bash
exit
```

## 故障排除


- **`enable` 命令未生效**：如果输入 `enable` 命令没有生效，可以尝试重新安装：

  ```bash
  sudo ./install-frr
  ```


## 卸载

如果你需要卸载 FRRouting 和所有相关配置，可以使用以下命令：

```bash
# 卸载 FRRouting 包
sudo apt remove --purge frr 
```

## 许可

该项目使用 [MIT 许可协议](LICENSE)。你可以自由地使用、修改和分发此脚本，但请保留本许可声明。
