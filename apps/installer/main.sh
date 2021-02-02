#!/usr/bin/env bash

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_PATH/includes/includes.sh"

PS3='[请输入您的选择]: '
options=(
    "init (i): 第一次安装"                  # 1
    "install-deps (d): Configure OS dep"            # 2
    "pull (u): 更新存储库"                   # 3
    "reset (r): 重置和清理存储库"           # 4
    "compiler (c): 运行编译器工具"               # 5
    "db-assembler (a): 运行db汇编工具"       # 6
    "module-search (ms): 按关键字搜索模块" # 7
    "module-install (mi): 按名称安装模块"  # 8
    "module-update (mu): 按名称更新模块"    # 9
    "module-remove: (mr): 按名称删除模块"   # 10
    "client-data: (gd): 从github存储库下载客户端数据(测试版)"   # 11
    "run-worldserver (rw): 为worldserver执行一个简单的restarter" # 12
    "run-authserver (ra): 为authserver执行一个简单的restarter" # 13
    "quit: 退出此菜单"                     # 14
    )

function _switch() {
    _reply="$1"
    _opt="$2"

    case $_reply in
        ""|"i"|"init"|"1")
            inst_allInOne
            ;;
        ""|"d"|"install-deps"|"2")
            inst_configureOS
            ;;
        ""|"u"|"pull"|"3")
            inst_updateRepo
            ;;
        ""|"r"|"reset"|"4")
            inst_resetRepo
            ;;
        ""|"c"|"compiler"|"5")
            bash "$AC_PATH_APPS/compiler/compiler.sh" $_opt
            ;;
        ""|"a"|"db-assembler"|"6")
            bash "$AC_PATH_APPS/db_assembler/db_assembler.sh" $_opt
            ;;
        ""|"ms"|"module-search"|"7")
            inst_module_search "$_opt"
            ;;
        ""|"mi"|"module-install"|"8")
            inst_module_install "$_opt"
            ;;
        ""|"mu"|"module-update"|"9")
            inst_module_update "$_opt"
            ;;
        ""|"mr"|"module-remove"|"10")
            inst_module_remove "$_opt"
            ;;
        ""|"gd"|"client-data"|"11")
            inst_download_client_data
            ;;
        ""|"rw"|"run-worldserver"|"12")
            inst_simple_restarter worldserver
            ;;
        ""|"ra"|"run-authserver"|"13")
            inst_simple_restarter authserver
            ;;
        ""|"quit"|"14")
            echo "Goodbye!"
            exit
            ;;
        ""|"--help")
            echo "可用命令:"
            printf '%s\n' "${options[@]}"
            ;;
        *) echo "无效选项，在命令列表中使用——help选项";;
    esac
}

while true
do
    # run option directly if specified in argument
    [ ! -z $1 ] && _switch $@ # old method: "${options[$cmdopt-1]}"
    [ ! -z $1 ] && exit 0

    echo "==== ACORE DASHBOARD ===="
    select opt in "${options[@]}"
    do
        _switch $REPLY
        break
    done
done
