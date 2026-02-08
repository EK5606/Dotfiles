#!/bin/bash
# --- 定义颜色代码 ---
RED='\033[0;31m'    # 错误信息
GREEN='\033[0;32m'  # 成功信息
YELLOW='\033[0;33m' # 警告信息
BLUE='\033[0;34m'   # 普通信息
NC='\033[0m'        # 恢复默认颜色
# --- 辅助函数：日志记录 ---
# 普通信息
log_info() {
  echo -e "${BLUE}[INFO]${NC} $(date +'%Y-%m-%d %H:%M:%S') $1" >&2
}
# 成功信息
log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $(date +'%Y-%m-%d %H:%M:%S') $1" >&2
}
# 警告信息
log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $(date +'%Y-%m-%d %H:%M:%S') $1" >&2
}
# 错误信息 (并可以选择退出脚本)
log_error() {
  echo -e "${RED}[ERROR]${NC} $(date +'%Y-%m-%d %H:%M:%S') $1" >&2
  exit 1 # 遇到错误时退出脚本
}

# 检查root权限
if [ "$EUID" -ne 0 ]; then
  echo -e "需要root权限运行！"
  exit 1
fi

install_Fcitx5() {
  fcitx5_packages=(
    fcitx5
    fcitx5-gtk
    fcitx5-qt
    fcitx5-configtool
    fcitx5-breeze
    fcitx5-chinese-addons
    fcitx5-lua
    fcitx5-rime
  )
  for pkg in "${fcitx5_packages[@]}"; do
    log_info "正在安装$pkg..."     
    if pacman -S --noconfirm "$pkg" 2>&1; then
      log_success "成功安装$pkg"
    else 
      log_warning "$pkg安装失败"

  done
}

# 主菜单
main_menu() {
  while true; do
    clear
    log_info "主菜单"
    echo "1) 安装Fcitx5输入法"
    echo "2) 为xremap提权"
    read -p "请输入数字进行选择，q退出  " choice
    case "$choice" in
    1)
      log_info "开始安装Fcitx输入法..."
      ;;
    2)
      log_info "开始为xremap提权..."
      ;;
    q | Q)
      log_info "退出安装脚本"
      exit 0
      ;;

    esac
  done
}

main_menu
