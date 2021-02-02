#!/usr/bin/env bash

set -e

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_PATH/includes/includes.sh"

function run_option() {
    re='^[0-9]+$'
    if [[ $1 =~ $re ]] && test "${comp_functions[$1-1]+'test'}"; then
        ${comp_functions[$1-1]}
    elif [ -n "$(type -t comp_$1)" ] && [ "$(type -t comp_$1)" = function ]; then
        fun="comp_$1"
        $fun
    else
        echo "无效选项，在命令列表中使用——help选项"
    fi
}

function comp_quit() { 
    exit 0
}

comp_options=(
    "build: 配置和编译"
    "clean: 清洁构建文件"
    "configure: 运行CMake"
    "compile: 只编译" 
    "all: 清理、配置和编译"
    "quit: 关闭菜单")
comp_functions=(
    "comp_build" 
    "comp_clean" 
    "comp_configure" 
    "comp_compile"
    "comp_all"
    "comp_quit")

PS3='[ 请输入您的选择 ]: '

runHooks "ON_AFTER_OPTIONS" #您可以创建自定义选项

function _switch() {
    _reply="$1"
    _opt="$2"

    case $_reply in
        ""|"--help")
            echo "可用命令:"
            printf '%s\n' "${options[@]}"
            ;;
        *) 
            run_option $_reply $_opt
        ;;
    esac
}


while true
do
    # run option directly if specified in argument
    [ ! -z $1 ] && _switch $@
    [ ! -z $1 ] && exit 0

    select opt in "${comp_options[@]}"
    do
        echo "==== ACORE COMPILER ===="
        _switch $REPLY
        break;
    done
done
