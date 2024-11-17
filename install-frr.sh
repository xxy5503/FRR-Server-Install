#!/bin/bash

# 函数: 执行命令并检查是否成功
run_command() {
    command="$1"
    echo "Running: $command"
    eval "$command" 2>&1
    if [ $? -ne 0 ]; then
        echo "Error executing command: $command"
        exit 1
    fi
}

# 函数: 修改 /etc/frr/daemons 文件，将 no 替换为 yes
modify_daemons_file() {
    daemon_file="/etc/frr/daemons"
    
    if [ ! -f "$daemon_file" ]; then
        echo "Error: $daemon_file does not exist."
        exit 1
    fi

    echo "Modifying $daemon_file to replace 'no' with 'yes'..."
    
    # 使用 sed 命令将 no 替换为 yes
    sudo sed -i 's/=no/=yes/g' "$daemon_file"
}

# 1. 添加 GPG 密钥
echo "Adding GPG key for FRR repository..."
run_command "curl -s https://deb.frrouting.org/frr/keys.gpg | sudo tee /usr/share/keyrings/frrouting.gpg > /dev/null"

# 2. 设置 FRR 版本
FRRVER="frr-stable"  # 默认安装最新的稳定版本
echo "Setting up FRR repository for version $FRRVER..."

# 获取当前Ubuntu发行版的代号（如 focal, bionic, 等）
ubuntu_codename=$(lsb_release -s -c)

# 将 FRR 仓库添加到源列表
run_command "echo 'deb [signed-by=/usr/share/keyrings/frrouting.gpg] https://deb.frrouting.org/frr $ubuntu_codename $FRRVER' | sudo tee -a /etc/apt/sources.list.d/frr.list"

# 3. 更新APT包列表
echo "Updating package lists..."
run_command "sudo apt update"

# 4. 安装 FRR 及相关工具
echo "Installing FRR and frr-pythontools..."
run_command "sudo apt install -y frr frr-pythontools"

# 5. 启动并启用 FRR 服务
echo "Starting and enabling FRR service..."
run_command "sudo systemctl enable frr"
run_command "sudo systemctl start frr"

# 6. 验证安装
echo "Verifying FRR installation..."
run_command "frr --version"

# 7. 修改 /etc/frr/daemons 文件
modify_daemons_file

# 8. 重启 FRR 服务
echo "Restarting FRR service..."
run_command "sudo systemctl restart frr"

echo "alias enable='vtysh'" >> ~/.bashrc

run_command "source ~/.bashrc"


echo "FRR installation and configuration completed successfully."
