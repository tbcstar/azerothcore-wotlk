#!/usr/bin/env bash

set -e

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_PATH/includes/includes.sh"

cmdopt=$1

PS3='[请输入您的选择]: '
options=(
    "all: 装配所有"                              # 1
    "基础: 只装配基地"                      # 2
    "更新: 只组装更新"                 # 3
    "自定义: 只组装自定义"                  # 4
    "导入-all: 组装&导入所有"              # 5
    "导入-bases: 装配 & 只导入 bases"      # 6
    "导入-updates: 装配 & 只导入 updates" # 7
    "导入-customs:  装配 & 只导入 customs" # 8
    "quit:退出该菜单"                      # 9
    )

function _switch() {
    _reply="$1"
    _opt="$2"

    case $_reply in
        ""|"all"|"1")
            dbasm_run true true true
            ;;
        ""|"bases"|"2")
            dbasm_run true false false
            ;;
        ""|"updates"|"3")
            dbasm_run false true false
            ;;
        ""|"customs"|"4")
            dbasm_run false false true
            ;;
        ""|"import-all"|"5")
            dbasm_import true true true
            ;;
        ""|"import-bases"|"6")
            dbasm_import true false false
            ;;
        ""|"import-updates"|"7")
            dbasm_import false true false
            ;;
        ""|"import-customs"|"8")
            dbasm_import false false true
            ;;
        ""|"quit"|"9")
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
    [ ! -z $1 ] && _switch $@
    [ ! -z $1 ] && exit 0

    select opt in "${options[@]}"
    do
        echo "=====     DB汇编程序菜单     ====="
        _switch $REPLY
        break
    done
done
