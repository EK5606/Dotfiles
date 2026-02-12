#!/bin/bash
# --- 定义颜色代码 ---
RED='\033[0;31m'    # 错误信息
GREEN='\033[0;32m'  # 成功信息
YELLOW='\033[0;33m' # 警告信息
BLUE='\033[0;34m'   # 普通信息
NC='\033[0m'        # 恢复默认颜色

# --- ---
CURRENT_USER=$(logname)
USER_HOME=$(eval echo "~$CURRENT_USER")

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

install_fcitx5() {
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
  PLUM_DIR="$USER_HOME/plum"
  for pkg in "${fcitx5_packages[@]}"; do
    log_info "正在安装'$pkg'..."
    if pacman -Q "$pkg" &>/dev/null; then
      log_info "$pkg已经安装"
      continue
    fi
    if pacman -S --noconfirm "$pkg" 2>&1; then
      log_success "成功安装'$pkg'"
    else
      log_warning "'$pkg'安装失败"
      exit 1
    fi
  done
  if [ -d "$PLUM_DIR/.git" ]; then
    log_warning "检测到plum已安装，尝试更新..."
    if sudo -u "$CURRENT_USER" git -C "$PLUM_DIR" pull --rebase >/dev/null 2>&1; then
      log_info "plum更新完成"
    else
      log_error "plum更新失败"
    fi
  else
    log_info "正在克隆plum"
    if sudo -u "$CURRENT_USER" git clone --depth 1 https://github.com/rime/plum "$PLUM_DIR" >/dev/null 2>&1; then
      log_success "plum克隆成功"
    else
      log_error "plum克隆失败"
    fi
  fi

  log_info "安装rime-moran"
  if sudo -u "$CURRENT_USER" env rime_frontend=fcitx5-rime bash -c "cd '$PLUM_DIR' && ./rime-install rimeinn/rime-moran@simp"; then
    log_success "rime-moran安装成功"
  else
    log_error "$安装rime-moran失败！"
  fi
}

install_xremap() {
  if sudo -u "$CURRENT_USER" yay -S --noconfirm xremap-niri-bin 2>&1; then
    if gpasswd -a "$CURRENT_USER" input 2>&1; then
      if echo 'KERNEL=="input",GROUP="input",TAG+="uaccess",MODE:="0660",OPTIONS+="static_node=uinput"' | tee /etc/udev/rules.d/99-input.rules 2>&1; then
        log_success "tee ok"
      else
        log_warning "tee fail"
      fi
      log_success "input ok"
    else
      log_warning "input fail"
    fi
    log_success "yay ok"
  else
    log_warning "yay fail"
  fi

}

install_niri() {
  niri_packages=(
    niri
    xwayland-satellite
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    cliphist
    cava
    wlsunset
  )
  noctalia_packages=(
    noctalia-shell
  )
  included_files=(
    'include "binds.kdl"'
    'include "input.kdl"'
    'include "output.kdl"'
    'include "layout.kdl"'
    'include "rule.kdl"'
    'include "spawn.kdl"'
    'include "environment.kdl"'
  )
  config_file="$USER_HOME/.config/niri/config.kdl"
  for pkg in "${niri_packages[@]}"; do
    log_info "正在安装'$pkg'..."
    if pacman -Q "$pkg" &>/dev/null; then
      log_info "$pkg已经安装"
      continue
    fi
    if pacman -S --noconfirm "$pkg" 2>&1; then
      log_success "成功安装'$pkg'"
    else
      log_warning "'$pkg'安装失败"
      exit 1
    fi
  done
  for pkg in "${noctalia_packages[@]}"; do
    log_info "正在安装'$pkg'..."
    if pacman -Q "$pkg" &>/dev/null; then
      log_info "$pkg已经安装"
      continue
    fi
    if sudo -u $CURRENT_USER yay -S --noconfirm "$pkg" 2>&1; then
      log_success "成功安装'$pkg'"
    else
      log_warning "'$pkg'安装失败"
      exit 1
    fi
  done
  if [ ! -f "$config_file" ]; then
    log_error "没有$config_file！"
  fi

  for line in "${included_files[@]}"; do
    if ! sudo -u "$CURRENT_USER" grep -qF "$line" "$config_file" 2>&1; then
      echo "$line" | sudo -u "$CURRENT_USER" tee -a "$config_file" >/dev/null || log_warning "写入文件失败"command
      log_success "写入$line成功"
    else
      log_warning "$line已存在"
    fi
  done
}

install_basic() {
  theme_packages=(
    breeze
    breeze-gtk
    breeze-icons
    arc-gtk-theme-eos

  )
  font_packages=(
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    ttf-jetbrains-maple-mono-nf-xx-xx # 等宽nerd jetbrains + maple
    ttf-sarasa-gothic                 # 等宽 更纱

    ttf-nerd-fonts-symbols  #nerd图标字体
    ttf-ms-win11-auto-zh_cn # windows字体
  )
  app_packages=(
    qt6ct-kde
    font-manager
    konsole
    dolphin
    archlinux-xdg-menu

  )
  log_info "更改为英文目录.."
  mv $HOME/桌面 $HOME/Desktop
  mv $HOME/下载 $HOME/Downloads
  mv $HOME/模板 $HOME/Templates
  mv $HOME/公共 $HOME/Public
  mv $HOME/文档 $HOME/Documents
  mv $HOME/音乐 $HOME/Music
  mv $HOME/图片 $HOME/Pictures
  mv $HOME/视频 $HOME/Videos

  log_info "安装字体中..."
  mkdir /usr/share/fonts/WindowsFonts
}

install_terminal() {
  terminal_packages=(
    konsole

    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    zsh-theme-powerlevel10k
    autojump

    neovim
    lazygit
    btop
    pacseek-bin
    binsider
  )
  for pkg in "${terminal_packages[@]}"; do
    log_info "正在安装'$pkg'..."
    if sudo -u "$CURRENT_USER" yay -Q "$pkg" &>/dev/null; then
      log_info "$pkg已经安装"
      continue
    fi
    if sudo -u "$CURRENT_USER" yay -S --noconfirm "$pkg" 2>&1; then
      log_success "成功安装'$pkg'"
    else
      log_warning "'$pkg'安装失败"
      exit 1
    fi
  done

  log_info "配置zsh中..."
  if sudo -u "$CURRENT_USER" chsh -s /usr/bin/zsh 2>&1; then
    log_success "已设置zsh为默认shell"
  else
    log_error "设置zsh为默认shell失败"

  fi
}

install_game() {
  game_packages=(
    steam
    lutris

    mangohud
    mangojuice-bin
    vulkan-tools
    pascube
    goverlay
    gamescope
  )
}

install_code() {
  code_packages=(
    npm
    tree-sitter-cli
    visual-studio-code-bin
  )
}
# 主菜单
main_menu() {
  while true; do
    # clear
    log_info "主菜单"
    echo "1) 安装Fcitx5输入法"
    echo "2) 为xremap提权"
    echo "3) niri"
    echo "4) basic"
    echo "5) terminal"
    echo "6) game"
    echo "7) code"
    read -p "请输入数字进行选择，q退出  " choice
    case "$choice" in
    1)
      log_info "开始安装Fcitx输入法..."
      install_fcitx5
      ;;
    2)
      log_info "开始为xremap提权..."
      install_xremap
      ;;
    3)
      log_info "niri"
      install_niri
      ;;
    4)
      log_info "basic"
      ;;
    5)
      log_info "terminal"
      install_terminal
      ;;
    6)
      log_info "game"
      install_game
      ;;
    7)
      log_info "code"
      install_code
      ;;
    q)
      log_info "退出安装脚本"
      exit 0
      ;;

    esac
  done
}

main_menu
