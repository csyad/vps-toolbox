#!/bin/bash
# VPS Toolbox - 最终丝滑美化整合版（含完整执行逻辑）

INSTALL_PATH="$HOME/vps-toolbox.sh"
SHORTCUT_PATH="/usr/local/bin/m"
SHORTCUT_PATH_UPPER="/usr/local/bin/M"

# 颜色
reset="\033[0m"
green="\033[32m"
yellow="\033[33m"
red="\033[31m"
colors=(31 33 32 36 34 35)

# Ctrl+C 中断保护
trap 'echo -e "\n${red}操作已中断${reset}"; exit 1' INT

#========= 通用工具函数 =========#
confirm() {
    # confirm "提示语"
    read -rp "$1 [y/N]: " ans
    case "$ans" in
        y|Y|yes|YES) return 0 ;;
        *) echo -e "${yellow}已取消${reset}"; return 1 ;;
    esac
}

ok()   { echo -e "${green}✔ 成功${reset}"; }
fail() { echo -e "${red}✘ 失败${reset}"; }

run_cmd() {
    # run_cmd "描述" "命令..."
    local desc="$1"; shift
    echo -e "${yellow}➤ ${desc}${reset}"
    bash -c "$@"
    local code=$?
    if [ $code -eq 0 ]; then ok; else fail; fi
    return $code
}

#========= 动态彩虹标题 =========#
rainbow_animation() {
    local text="🌈 VPS Toolbox 🌈"
    local len=${#text}
    local loops=42
    for ((i=0; i<loops; i++)); do
        local output=""
        for ((c=0; c<len; c++)); do
            output+="\033[${colors[$(((c+i)%${#colors[@]}))]}m${text:$c:1}"
        done
        echo -ne "\r${output}${reset}"
        sleep 0.04
    done
    echo -e "\n"
}

#========= 系统资源显示 =========#
show_system_usage() {
    local width=36
    mem_used=$(free -m | awk '/Mem:/ {print $3}')
    mem_total=$(free -m | awk '/Mem:/ {print $2}')
    disk_used_percent=$(df -h / | awk 'NR==2 {print $5}')
    disk_total=$(df -h / | awk 'NR==2 {print $2}')
    cpu_usage=$(grep 'cpu ' /proc/stat | awk '{u=($2+$4)*100/($2+$4+$5)} END {printf "%.1f", u}')
    pad() { local str="$1"; printf "%-${width}s" "$str"; }
    echo -e "${yellow}┌$(printf '─%.0s' $(seq 1 $width))┐${reset}"
    echo -e "${yellow}│$(pad "📊 内存：${mem_used}Mi / ${mem_total}Mi")│${reset}"
    echo -e "${yellow}│$(pad "💽 磁盘：${disk_used_percent} / 总 ${disk_total}")│${reset}"
    echo -e "${yellow}│$(pad "⚙ CPU：${cpu_usage}%")│${reset}"
    echo -e "${yellow}└$(printf '─%.0s' $(seq 1 $width))┘${reset}\n"
}

#========= 彩虹边框 & 菜单项 =========#
rainbow_border() {
    local text="$1"
    local output=""
    local i=0
    for (( c=0; c<${#text}; c++ )); do
        output+="\033[${colors[$i]}m${text:$c:1}"
        ((i=(i+1)%${#colors[@]}))
    done
    echo -e "$output${reset}"
}

print_option() {
    local num="$1"
    local text="$2"
    printf "${green}%02d  %-30s${reset}\n" "$num" "$text"
}

#========= 菜单 =========#
show_menu() {
    clear
    show_system_usage
    rainbow_border "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    rainbow_border "    📦 服务器工具箱 📦"
    rainbow_border "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo -e "${red}【系统设置】${reset}"
    print_option 1  "更新源"
    print_option 2  "更新curl"
    print_option 3  "DDNS"
    print_option 4  "本机信息"
    print_option 5  "DDWin10（危险）"
    print_option 6  "临时禁用IPv6"
    print_option 7  "添加SWAP"
    print_option 8  "TCP窗口调优"
    print_option 9  "安装Python"
    print_option 10 "自定义DNS解锁"

    echo -e "\n${red}【哪吒相关】${reset}"
    print_option 11 "哪吒压缩包依赖（unzip）"
    print_option 12 "卸载哪吒探针（危险）"
    print_option 13 "哪吒 v1 关 SSH"
    print_option 14 "哪吒 v0 关 SSH"
    print_option 15 "V0哪吒（Argo容器）"

    echo -e "\n${red}【面板相关】${reset}"
    print_option 16 "宝塔面板"
    print_option 17 "1Panel 面板"
    print_option 18 "宝塔开心版"
    print_option 19 "极光面板"
    print_option 20 "哆啦A梦转发面板"

    echo -e "\n${red}【代理】${reset}"
    print_option 21 "HY2"
    print_option 22 "3XUI"
    print_option 23 "WARP"
    print_option 24 "SNELL"
    print_option 25 "国外 EZRealm"
    print_option 26 "国内 EZRealm"
    print_option 27 "3x-ui-alpines（Alpine）"
    print_option 28 "gost"

    echo -e "\n${red}【网络解锁 / 测试】${reset}"
    print_option 29 "IP解锁-IPv4"
    print_option 30 "IP解锁-IPv6"
    print_option 31 "网络质量-IPv4"
    print_option 32 "网络质量-IPv6"
    print_option 33 "NodeQuality 脚本"
    print_option 34 "流媒体解锁测试"
    print_option 35 "融合怪测试"
    print_option 36 "国外三网测速"
    print_option 37 "国内三网测速"
    print_option 38 "国外三网延迟测试"
    print_option 39 "国内三网延迟测试"

    echo -e "\n${red}【应用商店】${reset}"
    print_option 40 "Sub-Store（Docker）"
    print_option 41 "WEBSSH（Docker）"
    print_option 42 "Poste.io 邮局"
    print_option 43 "OpenList"

    echo -e "\n${red}【工具箱】${reset}"
    print_option 44 "老王工具箱"
    print_option 45 "科技 lion"
    print_option 46 "一点科技"
    print_option 47 "服务器优化"
    print_option 48 "VPS Toolkit"

    echo -e "\n${red}【Docker 工具】${reset}"
    print_option 49 "安装 Docker Compose"
    print_option 50 "Docker 备份和恢复"
    print_option 51 "Docker 容器迁移"

    echo -e "\n${red}【证书 / 反代】${reset}"
    print_option 52 "NGINX 反代（KeJiLion）"

    echo -e "\n${red}【其他】${reset}"
    print_option 88 "VPS 管理"
    print_option 99 "卸载本工具箱（危险）"
    print_option  0  "退出"

    rainbow_border "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

#========= 快捷方式 =========#
install_shortcut() {
    echo -e "${green}创建快捷指令 m 和 M${reset}"
    local script_path
    script_path=$(realpath "$0")
    sudo ln -sf "$script_path" "$SHORTCUT_PATH"
    sudo ln -sf "$script_path" "$SHORTCUT_PATH_UPPER"
    sudo chmod +x "$script_path"
    echo -e "${green}安装完成！输入 m 或 M 运行工具箱${reset}"
}

remove_shortcut() {
    sudo rm -f "$SHORTCUT_PATH" "$SHORTCUT_PATH_UPPER"
    echo -e "${red}已删除快捷指令 m 和 M${reset}"
}

#========= 执行逻辑（完整 case） =========#
execute_choice() {
    case "$1" in
        1)  run_cmd "更新源" "sudo apt update" ;;
        2)  run_cmd "安装 curl" "sudo apt install curl -y" ;;
        3)  run_cmd "执行 DDNS 脚本" "bash <(wget -qO- https://raw.githubusercontent.com/mocchen/cssmeihua/mochen/shell/ddns.sh)" ;;
        4)  run_cmd "获取本机信息" "bash <(curl -fsSL https://raw.githubusercontent.com/iu683/vps-tools/main/vpsinfo.sh)" ;;
        5)  if confirm "将重装为 Windows 10（DD 重装），确定继续？"; then
                run_cmd "DD Windows 10" "bash <(curl -sSL https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh) -windows 10 -lang \"cn\""
            fi ;;
        6)  run_cmd "临时禁用 IPv6" "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1" ;;
        7)  run_cmd "添加 SWAP" "wget https://www.moerats.com/usr/shell/swap.sh && bash swap.sh" ;;
        8)  run_cmd "TCP 窗口调优" "wget http://sh.nekoneko.cloud/tools.sh -O tools.sh && bash tools.sh" ;;
        9)  run_cmd "安装 Python" "curl -O https://raw.githubusercontent.com/lx969788249/lxspacepy/master/pyinstall.sh && chmod +x pyinstall.sh && ./pyinstall.sh" ;;
        10) run_cmd "自定义 DNS 解锁" "bash <(curl -sL https://raw.githubusercontent.com/iu683/vps-tools/main/media_dns.sh)" ;;

        11) run_cmd "安装 unzip" "sudo apt install unzip -y" ;;
        12) if confirm "将卸载哪吒探针，确认继续？"; then
                run_cmd "卸载哪吒探针" "bash <(curl -fsSL https://raw.githubusercontent.com/SimonGino/Config/master/sh/uninstall_nezha_agent.sh)"
            fi ;;
        13) run_cmd "哪吒 v1 关 SSH" "sed -i 's/disable_command_execute: false/disable_command_execute: true/' /opt/nezha/agent/config.yml && systemctl restart nezha-agent" ;;
        14) run_cmd "哪吒 v0 关 SSH" "sed -i 's|^ExecStart=.*|& --disable-command-execute --disable-auto-update --disable-force-update|' /etc/systemd/system/nezha-agent.service && systemctl daemon-reload && systemctl restart nezha-agent" ;;
        15) run_cmd "V0哪吒（Argo 容器）" "bash <(wget -qO- https://raw.githubusercontent.com/fscarmen2/Argo-Nezha-Service-Container/main/dashboard.sh)" ;;

        16) run_cmd "安装宝塔面板" "if [ -f /usr/bin/curl ]; then curl -sSO https://download.bt.cn/install/install_panel.sh; else wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh; fi; bash install_panel.sh ed8484bec" ;;
        17) run_cmd "安装 1Panel 面板" "bash -c \"\$(curl -sSL https://resource.fit2cloud.com/1panel/package/v2/quick_start.sh)\"" ;;
        18) run_cmd "宝塔开心版" "if [ -f /usr/bin/curl ]; then curl -sSO http://bt95.btkaixin.net/install/install_panel.sh; else wget -O install_panel.sh http://bt95.btkaixin.net/install/install_panel.sh; fi; bash install_panel.sh www.BTKaiXin.com" ;;
        19) run_cmd "安装极光面板" "bash <(curl -fsSL https://raw.githubusercontent.com/Aurora-Admin-Panel/deploy/main/install.sh)" ;;
        20) run_cmd "安装哆啦A梦转发面板" "curl -L https://raw.githubusercontent.com/bqlpfy/forward-panel/refs/heads/main/panel_install.sh -o panel_install.sh && chmod +x panel_install.sh && ./panel_install.sh" ;;

        21) run_cmd "安装 HY2" "wget -N --no-check-certificate https://raw.githubusercontent.com/flame1ce/hysteria2-install/main/hysteria2-install-main/hy2/hysteria.sh && bash hysteria.sh" ;;
        22) run_cmd "安装 3XUI" "bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)" ;;
        23) run_cmd "WARP 安装/管理" "wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh" ;;
        24) run_cmd "安装 SNELL" "bash <(curl -L -s menu.jinqians.com)" ;;
        25) run_cmd "国外 EZRealm" "wget -N https://raw.githubusercontent.com/shiyi11yi/EZRealm/main/realm.sh && chmod +x realm.sh && ./realm.sh" ;;
        26) run_cmd "国内 EZRealm" "wget -N https://raw.githubusercontent.com/shiyi11yi/EZRealm/main/CN/realm.sh && chmod +x realm.sh && ./realm.sh" ;;
        27) run_cmd "3x-ui-alpines (Alpine)" "apk add curl bash gzip openssl && bash <(curl -Ls https://raw.githubusercontent.com/StarVM-OpenSource/3x-ui-Apline/refs/heads/main/install.sh)" ;;
        28) run_cmd "安装 gost" "wget --no-check-certificate -O gost.sh https://raw.githubusercontent.com/qqrrooty/EZgost/main/gost.sh && chmod +x gost.sh && ./gost.sh" ;;

        29) run_cmd "IP 解锁 - IPv4" "bash <(curl -Ls https://IP.Check.Place) -4" ;;
        30) run_cmd "IP 解锁 - IPv6" "bash <(curl -Ls https://IP.Check.Place) -6" ;;
        31) run_cmd "网络质量 - IPv4" "bash <(curl -Ls https://Net.Check.Place) -4" ;;
        32) run_cmd "网络质量 - IPv6" "bash <(curl -Ls https://Net.Check.Place) -6" ;;
        33) run_cmd "NodeQuality 脚本" "bash <(curl -sL https://run.NodeQuality.com)" ;;
        34) run_cmd "流媒体解锁测试" "bash <(curl -L -s https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/check.sh)" ;;
        35) run_cmd "融合怪测试" "curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh" ;;
        36) run_cmd "国外三网测速" "bash <(wget -qO- bash.spiritlhl.net/ecs-cn)" ;;
        37) run_cmd "国内三网测速" "bash <(wget -qO- --no-check-certificate https://cdn.spiritlhl.net/https://raw.githubusercontent.com/spiritLHLS/ecsspeed/main/script/ecsspeed-cn.sh)" ;;
        38) run_cmd "国外三网延迟测试" "bash <(wget -qO- bash.spiritlhl.net/ecs-ping)" ;;
        39) run_cmd "国内三网延迟测试" "bash <(wget -qO- --no-check-certificate https://cdn.spiritlhl.net/https://raw.githubusercontent.com/spiritLHLS/ecsspeed/main/script/ecsspeed-ping.sh)" ;;

        40) run_cmd "部署 Sub-Store (Docker)" "docker run -it -d --restart=always -e \"SUB_STORE_CRON=0 0 * * *\" -e SUB_STORE_FRONTEND_BACKEND_PATH=/2cXaAxRGfddmGz2yx1wA -p 3001:3001 -v /root/sub-store-data:/opt/app/data --name sub-store xream/sub-store" ;;
        41) run_cmd "部署 WEBSSH (Docker)" "docker run -d --name webssh --restart always -p 8888:8888 cmliu/webssh:latest" ;;
        42) run_cmd "安装 Poste.io 邮局" "curl -sS -O https://raw.githubusercontent.com/woniu336/open_shell/main/poste_io.sh && chmod +x poste_io.sh && ./poste_io.sh" ;;
        43) run_cmd "安装 OpenList" "curl -fsSL https://res.oplist.org/script/v4.sh > install-openlist-v4.sh && sudo bash install-openlist-v4.sh" ;;

        44) run_cmd "老王工具箱" "curl -fsSL https://raw.githubusercontent.com/eooce/ssh_tool/main/ssh_tool.sh -o ssh_tool.sh && chmod +x ssh_tool.sh && ./ssh_tool.sh" ;;
        45) run_cmd "科技 lion" "curl -sS -O https://kejilion.pro/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh" ;;
        46) run_cmd "一点科技" "wget -O 1keji.sh \"https://www.1keji.net\" && chmod +x 1keji.sh && ./1keji.sh" ;;
        47) run_cmd "服务器优化" "bash <(curl -sL ss.hide.ss)" ;;
        48) run_cmd "VPS Toolkit" "bash <(curl -sSL https://raw.githubusercontent.com/zeyu8023/vps_toolkit/main/install.sh)" ;;

        49) run_cmd "安装 docker-compose-plugin (APT)" "sudo apt install docker-compose-plugin -y" ;;
        50) run_cmd "Docker 备份与恢复" "curl -fsSL https://raw.githubusercontent.com/xymn2023/DMR/main/docker_back.sh -o docker_back.sh && chmod +x docker_back.sh && ./docker_back.sh" ;;
        51) run_cmd "Docker 容器迁移" "curl -O https://raw.githubusercontent.com/ceocok/Docker_container_migration/refs/heads/main/Docker_container_migration.sh && chmod +x Docker_container_migration.sh && ./Docker_container_migration.sh" ;;

        52) run_cmd "NGINX 反代（KeJiLion）" "bash <(curl -sL kejilion.sh) fd" ;;

        88) run_cmd "VPS 管理" "curl -fsSL https://raw.githubusercontent.com/iu683/vps-tools/main/vps-control.sh -o vps-control.sh && chmod +x vps-control.sh && ./vps-control.sh" ;;

        99) if confirm "确定要卸载本工具箱并移除快捷方式吗？"; then
                echo -e "${red}卸载工具箱...${reset}"
                rm -f "$INSTALL_PATH" "$(realpath "$0")"
                remove_shortcut
                echo -e "${green}卸载完成${reset}"
                exit 0
            fi ;;

        0)  echo -e "${yellow}退出${reset}"; exit 0 ;;
        *)  echo -e "${red}无效选项${reset}" ;;
    esac
}

#========= 启动准备 =========#
if [ ! -f "$SHORTCUT_PATH" ] || [ ! -f "$SHORTCUT_PATH_UPPER" ]; then
    install_shortcut
fi

# 启动动画
rainbow_animation

#========= 主循环 =========#
while true; do
    show_menu
    read -rp "请输入选项编号: " choice
    execute_choice "$choice"
    echo
    read -rp "按回车返回菜单..."
done
