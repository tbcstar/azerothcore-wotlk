function inst_configureOS() {
    echo "Platform: $OSTYPE"
    case "$OSTYPE" in
        solaris*) echo "目前还不支持Solaris" ;;
        darwin*)  source "$AC_PATH_INSTALLER/includes/os_configs/osx.sh" ;;  
        linux*)
            # 如果设置了$OSDISTRO，使用这个值(从config.sh)
            if [ ! -z "$OSDISTRO" ]; then
                DISTRO=$OSDISTRO
            # 如果可用，使用LSB来识别分布
            elif command -v lsb_release >/dev/null 2>&1 ; then
                DISTRO=$(lsb_release -is)
            # Otherwise, use release info file
            else
                DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
            fi

            case $DISTRO in
            # 在这里添加基于debian或ubuntu的发行版
            # TODO: find a better way, maybe checking the existance
            # of a package manager
                "neon" | "ubuntu" | "Ubuntu")
                    DISTRO="ubuntu"
                ;;
                "debian" | "Debian")
                    DISTRO="debian"
                ;;
                *)
                    echo "发行版: $DISTRO, 不支持。如果你的发行版是基于debian或ubuntu的，
                        请将“OSDISTRO”环境变量设置为其中一个发行版(你可以使用config.sh文件)"
                ;;
            esac


            DISTRO=${DISTRO,,}

            echo "发行版: $DISTRO"

            # 待办事项:按发行版实现不同的配置
            source "$AC_PATH_INSTALLER/includes/os_configs/$DISTRO.sh"
        ;;
        bsd*)     echo "目前还不支持BSD" ;;
        msys*)    source "$AC_PATH_INSTALLER/includes/os_configs/windows.sh" ;;
        *)        echo "跳出的警告" ;;
    esac
}

function inst_updateRepo() {
    cd "$AC_PATH_ROOT"
    git pull origin $(git rev-parse --abbrev-ref HEAD)
}

function inst_resetRepo() {
    cd "$AC_PATH_ROOT"
    git reset --hard $(git rev-parse --abbrev-ref HEAD)
    git clean -f
}

function inst_compile() {
    comp_configure
    comp_build
}

function inst_cleanCompile() {
    comp_clean
    inst_compile
}

function inst_allInOne() {
    inst_configureOS
    inst_updateRepo
    inst_compile
    dbasm_import true true true
}

function inst_getVersionBranch() {
    local res="master"
    local v="not-defined"
    local MODULE_MAJOR=0
    local MODULE_MINOR=0
    local MODULE_PATCH=0
    local MODULE_SPECIAL=0;
    local ACV_MAJOR=0
    local ACV_MINOR=0
    local ACV_PATCH=0
    local ACV_SPECIAL=0;
    local curldata=$(curl -f --silent -H 'Cache-Control: no-cache' "$1" || echo "{}")
    local parsed=$(echo "$curldata" | "$AC_PATH_DEPS/jsonpath/JSONPath.sh" -b '$.compatibility.*.[version,branch]')

    semverParseInto "$ACORE_VERSION" ACV_MAJOR ACV_MINOR ACV_PATCH ACV_SPECIAL

    if [[ ! -z "$parsed" ]]; then
        readarray -t vers < <(echo "$parsed")
        local idx
        res="none"
        # since we've the pair version,branch alternated in not associative and one-dimensional
        # array, we've to simulate the association with length/2 trick
        for idx in `seq 0 $((${#vers[*]}/2-1))`; do
            semverParseInto "${vers[idx*2]}" MODULE_MAJOR MODULE_MINOR MODULE_PATCH MODULE_SPECIAL
            if [[ $MODULE_MAJOR -eq $ACV_MAJOR && $MODULE_MINOR -le $ACV_MINOR ]]; then
                res="${vers[idx*2+1]}"
                v="${vers[idx*2]}"
            fi
        done
    fi

    echo "$v" "$res"
}

function inst_module_search {

    local res="$1"
    local idx=0;

    if [ -z "$1" ]; then
        echo "键入要搜索的内容，或为完整列表留空"
        read -p "Insert name: " res
    fi

    local search="+$res"

    echo "搜索 $res..."
    echo "";

    readarray -t MODS < <(curl --silent "https://api.github.com/search/repositories?q=org%3Aazerothcore${search}+fork%3Atrue+topic%3Acore-module+sort%3Astars&type=" \
        | "$AC_PATH_DEPS/jsonpath/JSONPath.sh" -b '$.items.*.name')
    while (( ${#MODS[@]} > idx )); do
        mod="${MODS[idx++]}"
        read v b < <(inst_getVersionBranch "https://raw.githubusercontent.com/azerothcore/$mod/master/acore-module.json")

        if [[ "$b" != "none" ]]; then
            echo "-> $mod (测试过的AC版本: $v)"
        else
            echo "-> $mod (AC没有修订版 v$AC_VERSION, 它不能工作!)"
        fi
    done

    echo "";
    echo "";
}

function inst_module_install {
    local res
    if [ -z "$1" ]; then
        echo "键入要安装的模块的名称"
        read -p "Insert name: " res
    else
        res="$1"
    fi

    read v b < <(inst_getVersionBranch "https://raw.githubusercontent.com/azerothcore/$res/master/acore-module.json")

    if [[ "$b" != "none" ]]; then
        Joiner:add_repo "https://github.com/azerothcore/$res" "$res" "$b" && echo "完成后，请重新运行编译和数据库汇编。更多信息请阅读模块存储库的说明"
    else
        echo "不能安装 $res 模块: 它不存在或没有与AC v$ACORE_VERSION 兼容的版本可用"   
    fi

    echo "";
    echo "";
}

function inst_module_update {
    local res;
    local _tmp;
    local branch;
    local p;

    if [ -z "$1" ]; then
        echo "键入要更新的模块的名称"
        read -p "Insert name: " res
    else
        res="$1"
    fi

    _tmp=$PWD

    if [ -d "$J_PATH_MODULES/$res/" ]; then
        read v b < <(inst_getVersionBranch "https://raw.githubusercontent.com/azerothcore/$res/master/acore-module.json")

        cd "$J_PATH_MODULES/$res/"

        # 如果json有问题，请使用当前分支
        if [[ "$v" == "none" || "$v" == "not-defined" ]]; then
            b=`git rev-parse --abbrev-ref HEAD`
        fi

        Joiner:upd_repo "https://github.com/azerothcore/$res" "$res" "$b" && echo "完成后，请重新运行编译和数据库汇编" || echo "无法更新"
        cd $_tmp
    else
        echo "不能更新!路径不存在"
    fi;

    echo "";
    echo "";
}

function inst_module_remove {
    if [ -z "$1" ]; then
        echo "键入要删除的模块的名称"
        read -p "Insert name: " res
    else
        res="$1"
    fi

    Joiner:remove "$res" && echo "完成，请重新运行编译"  || echo "不能清除"

    echo "";
    echo "";
}


function inst_simple_restarter {
    echo "运行 $1 ..."
    bash "$AC_PATH_APPS/startup-scripts/simple-restarter" "$AC_BINPATH_FULL" "$1"
    echo
    #disown -a
    #jobs -l
}

function inst_download_client_data {
    local path="$AC_BINPATH_FULL"

    echo "下载客户端数据: $path/data.zip ..."
    curl -L https://github.com/wowgaming/client-data/releases/download/v9/data.zip > "$path/data.zip" \
        && unzip -o "$path/data.zip" -d "$path/" && rm "$path/data.zip"
}
