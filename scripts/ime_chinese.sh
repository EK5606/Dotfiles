#!/bin/bash

# 添加颜色变量以便更醒目的提示
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # 恢复默认颜色

# 检查 root 权限
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}错误：必须使用 root 权限运行本脚本！${NC}"
    echo -e "请尝试使用 ${YELLOW}sudo $0${NC} 命令"
    exit 1
fi

# 获取实际用户信息
CURRENT_USER=$(logname)
USER_HOME=$(eval echo "~$CURRENT_USER")

# 安装Firefox汉化
echo -e "${GREEN}▶ 开始安装 Firefox汉化...${NC}"
if pacman -S --noconfirm firefox-i18n-zh-cn; then
    echo -e "${GREEN}✓ 成功安装：firefox-i18n-zh-cn ${NC}"
else
    echo -e "${RED}错误：安装 firefox-i18n-zh-cn 失败！${NC}"
    exit 1
fi

echo -e "${GREEN}▶ 开始安装 Fcitx5 输入法组件...${NC}"

# 安装依赖包列表
fcitx_packages=(
    fcitx5
    fcitx5-gtk
    fcitx5-qt
    fcitx5-configtool
    fcitx5-lua
    fcitx5-material-color
    fcitx5-chinese-addons
    fcitx5-rime
    fcitx5-breeze
)

# 批量安装软件包
for pkg in "${fcitx_packages[@]}"; do
    echo -e "${YELLOW}正在安装：$pkg ...${NC}"
    if pacman -S --noconfirm "$pkg" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ 成功安装：$pkg${NC}"
    else
        echo -e "${RED}错误：安装 $pkg 失败！${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✓ 所有软件包安装完成！${NC}"

# 创建环境配置文件
CONFIG_DIR="$USER_HOME/.config/environment.d"
CONFIG_FILE="$CONFIG_DIR/im.conf"

echo -e "${YELLOW}正在配置输入法环境变量...${NC}"

# 以实际用户身份创建目录和文件
if sudo -u "$CURRENT_USER" mkdir -p "$CONFIG_DIR" && \
   sudo -u "$CURRENT_USER" tee "$CONFIG_FILE" >/dev/null <<EOF
XMODIFIERS=@im=fcitx
EOF
then
    echo -e "${GREEN}✓ 配置文件已创建：${CONFIG_FILE}${NC}"
else
    echo -e "${RED}错误：配置文件创建失败！${NC}"
    exit 1
fi

# 安装plum
echo -e "${GREEN}▶ 开始安装plum及rime-moran输入方案...${NC}"
PLUM_DIR="$USER_HOME/plum"

# 克隆/更新plum仓库
if [ -d "$PLUM_DIR/.git" ]; then
    echo -e "${YELLOW}检测到plum已安装，尝试更新...${NC}"
    if sudo -u "$CURRENT_USER" git -C "$PLUM_DIR" pull --rebase >/dev/null 2>&1; then
        echo -e "${GREEN}✓ plum更新成功${NC}"
    else
        echo -e "${YELLOW}⚠ 更新失败，尝试清理后重新克隆...${NC}"
        rm -rf "$PLUM_DIR"
        if sudo -u "$CURRENT_USER" git clone --depth 1 https://github.com/rime/plum "$PLUM_DIR" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ plum重新克隆成功${NC}"
        else
            echo -e "${RED}错误：克隆plum仓库失败！${NC}"
            exit 1
        fi
    fi
else
    echo -e "${YELLOW}正在克隆plum仓库...${NC}"
    if sudo -u "$CURRENT_USER" git clone --depth 1 https://github.com/rime/plum "$PLUM_DIR" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ plum克隆成功${NC}"
    else
        echo -e "${RED}错误：克隆plum仓库失败！${NC}"
        exit 1
    fi
fi

# 安装rime-moran输入方案
echo -e "${YELLOW}正在配置rime-moran输入方案...${NC}"
if sudo -u "$CURRENT_USER" env rime_frontend=fcitx5-rime bash -c "cd '$PLUM_DIR' && ./rime-install rimeinn/rime-moran@simp"; then
    echo -e "${GREEN}✓ rime-moran安装成功${NC}"
else
    echo -e "${RED}错误：安装rime-moran失败！${NC}"
    exit 1
fi

# 安装字体包列表
font_packages_pacman=(
    adobe-source-han-serif-cn-fonts
    adobe-source-han-sans-cn-fonts
    adobe-source-code-pro-fonts
    wqy-zenhei
    ttf-jetbrains-mono-nerd
    ttf-fira-code
    ttf-sarasa-gothic
    ttf-iosevka-nerd
)
font_packages_aur=(
    ttf-wps-fonts
    ttf-nerd-fonts-symbols-mono
    ttf-lxgw-wenkai-mono-nerd
)

#安装字体
echo -e "${YELLOE}正在配置中文字体...${NC}"
if

echo -e "\n${GREEN}✅ 所有操作已完成！${NC}"
