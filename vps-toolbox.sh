#!/bin/bash

# 颜色定义
RED="\033[31m"
GREEN="\033[32m"
RESET="\033[0m"

# 📊 系统状态信息（只显示一次）
show_system_info() {
    mem_used=$(free -m | awk '/Mem:/ {print $3}')
    mem_total=$(free -m | awk '/Mem:/ {print $2}')
    disk_used=$(df -h / | awk 'NR==2 {print $5}')
    disk_total=$(df -h / | awk 'NR==2 {print $2}')
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    cpu_usage=$(printf "%.1f" "$cpu_usage")

    echo "┌────────────────────────────────────┐"
    printf "📊 内存：%sMi/%sMi\n" "$mem_used" "$mem_total"
    printf "💽 磁盘：%s 用 / 总 %s\n" "$disk_used" "$disk_total"
    printf "⚙ CPU：%s%%\n" "$cpu_usage"
    echo "└────────────────────────────────────┘"
}

# 菜单显示
show_menu() {
    echo -e "${RED}【系统设置】${RESET}"
    echo -e "${GREEN}1. 更新源                  2. 更新curl${RESET}"
    echo -e "${GREEN}3. 本机信息                4. DDNS${RESET}"
    echo -e "${GREEN}5. 临时禁用IPv6            6. 添加SWAP${RESET}"
    echo -e "${GREEN}7. TCP窗口调优             8. 安装Python${RESET}"
    echo -e "${GREEN}9. 自定义DNS解锁           10. DDWin10${RESET}"

    echo -e "${RED}【哪吒相关】${RESET}"
    echo -e "${GREEN}11. 哪吒压缩包             12. 卸载哪吒探针${RESET}"
    echo -e "${GREEN}13. v1关SSH                14. v0关SSH${RESET}"
    echo -e "${GREEN}15. V0哪吒${RESET}"

    echo -e "${RED}【工具箱】${RESET}"
    echo -e "${GREEN}16. 老王工具箱             17. 科技lion${RESET}"
    echo -e "${GREEN}18. 服务器优化             19. VPS Toolkit${RESET}"
    echo -e "${GREEN}20. 一点科技${RESET}"

    echo -e "${RED}【代理工具】${RESET}"
    echo -e "${GREEN}21. HY2                   22. 3XUI${RESET}"
    echo -e "${GREEN}23. SNELL                 24. 国外EZRealm${RESET}"
    echo -e "${GREEN}25. 国内EZRealm           26. 3x-ui-alpines${RESET}"
    echo -e "${GREEN}27. gost                  28. WARP${RESET}"

    echo -e "${RED}【应用商店】${RESET}"
    echo -e "${GREEN}29. WEBSSH                30. Poste.io 邮局${RESET}"
    echo -e "${GREEN}31. Sub-Store             32. OpenList${RESET}"

    echo -e "${RED}【面板管理】${RESET}"
    echo -e "${GREEN}33. 极光面板               34. 哆啦A梦转发面板${RESET}"

    echo -e "${RED}【网络解锁】${RESET}"
    echo -e "${GREEN}35. 流媒体解锁             36. 融合怪测试${RESET}"
    echo -e "${GREEN}37. IP解锁-IPv4            38. IP解锁-IPv6${RESET}"
    echo -e "${GREEN}39. 网络质量-IPv4          40. 网络质量-IPv6${RESET}"
    echo -e "${GREEN}41. NodeQuality脚本${RESET}"

    echo -e "${RED}【Docker工具】${RESET}"
    echo -e "${GREEN}42. 安装 Docker Compose    43. Docker备份和恢复${RESET}"
    echo -e "${GREEN}44. Docker容器迁移${RESET}"

    echo -e "${RED}【证书工具】${RESET}"
    echo -e "${GREEN}45. NGINX反代${RESET}"

    echo -e "${GREEN}99. 卸载工具箱             0. 退出${RESET}"
}

# 执行功能
run_option() {
    case "$1" in
        1) sudo apt update ;;
        2) sudo apt install curl -y ;;
        3) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/get_sysinfo.sh) ;;
        4) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/ddns.sh) ;;
        5) sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 ;;
        6) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/add_swap.sh) ;;
        7) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/tcp_tune.sh) ;;
        8) sudo apt install python3 -y ;;
        9) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/custom_dns_unlock.sh) ;;
        10) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/dd_win10.sh) ;;
        11) apt install unzip -y ;;
        12) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/uninstall_nezha.sh) ;;
        13) echo "执行 v1 关SSH脚本" ;;
        14) echo "执行 v0 关SSH脚本" ;;
        15) echo "执行 V0哪吒安装脚本" ;;
        16) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/laowang_tool.sh) ;;
        17) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/kejilion.sh) ;;
        18) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/server_optimize.sh) ;;
        19) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/vps_toolkit.sh) ;;
        20) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/yidian_keji.sh) ;;
        21) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/hy2.sh) ;;
        22) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/3xui.sh) ;;
        23) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/snell.sh) ;;
        24) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/ezrealm_foreign.sh) ;;
        25) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/ezrealm_cn.sh) ;;
        26) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/3xui_alpine.sh) ;;
        27) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/gost.sh) ;;
        28) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/warp.sh) ;;
        29) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/webssh.sh) ;;
        30) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/posteio.sh) ;;
        31) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/substore.sh) ;;
        32) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/openlist.sh) ;;
        33) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/aurora_panel.sh) ;;
        34) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/doraemon_panel.sh) ;;
        35) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/media_unlock.sh) ;;
        36) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/fusion_test.sh) ;;
        37) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/ip_unlock_ipv4.sh) ;;
        38) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/ip_unlock_ipv6.sh) ;;
        39) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/net_quality_ipv4.sh) ;;
        40) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/net_quality_ipv6.sh) ;;
        41) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/nodequality.sh) ;;
        42) sudo apt install docker-compose -y ;;
        43) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/docker_backup.sh) ;;
        44) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/docker_migrate.sh) ;;
        45) bash <(curl -fsSL https://raw.githubusercontent.com/xxx/nginx_proxy.sh) ;;
        99) rm -f "$0" && echo "工具箱已卸载" && exit ;;
        0) exit ;;
        *) echo "无效选项，请重新输入" ;;
    esac
}

# 主循环
clear
show_system_info
echo
while true; do
    show_menu
    echo
    read -p "请输入选项编号: " choice
    run_option "$choice"
    echo
done
