function registerHooks() { hwc_event_register_hooks "$@"; }
function runHooks() { hwc_event_run_hooks "$@"; }

source "$AC_PATH_CONF/dist/config.sh" # include dist to avoid missing conf variables

if [ -f "$AC_PATH_CONF/config.sh"  ]; then
    source "$AC_PATH_CONF/config.sh" # should overwrite previous
else
    echo "通知: 文件 <$AC_PATH_CONF/config.sh> 没有找到，您应该创建并配置它。"
fi

#
# 加载模块
#

for entry in "$AC_PATH_MODULES/"*/include.sh
do
    if [ -e "$entry" ]; then 
        source "$entry"
    fi
done

ACORE_VERSION=$("$AC_PATH_DEPS/jsonpath/JSONPath.sh" -f "$AC_PATH_ROOT/acore.json" -b '$.version')
