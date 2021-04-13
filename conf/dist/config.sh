# absolute root path of your azerothcore repository
# It should not be modified if you don't really know what you're doing
SRCPATH="$AC_PATH_ROOT"

# absolute path where build files must be stored
BUILDPATH="$AC_PATH_ROOT/var/build/obj"

# absolute path where binary files must be stored
BINPATH="$AC_PATH_ROOT/env/dist"

# bash fills it by default with your os type. No need to change it.
# Change it if you really know what you're doing.
# OSTYPE=""

# When using linux, our installer automatically get information about your distro
# using lsb_release. If your distro is not supported but it's based on ubuntu or debian,
# please change it to one of these values.
#OSDISTRO="ubuntu"

# absolute path where config. files must be stored
# default: the system will use binpath by default
# CONFDIR="$AC_PATH_ROOT/env/dist/etc/"

##############################################
#
#  编译器配置
#
##############################################


# 设置首选的编译器。
# To use gcc (not suggested) instead of clang change in:
#  CCOMPILERC="/usr/bin/gcc"
#  CCOMPILERCXX="/usr/bin/g++"
#
CCOMPILERC="/usr/bin/clang"
CCOMPILERCXX="/usr/bin/clang++"


# 编译时必须使用多少线程(保留0以使用所有可用的线程)
MTHREADS=0
# 在编译期间启用/禁用警告
CWARNINGS=ON
# 启用/禁用一些调试信息(它不是调试编译)
CDEBUG=OFF
# 指定编译类型
CTYPE=Release
# 脚本编译
CSCRIPTS=ON
# 编译单元测试
CBUILD_TESTING=OFF
# compile server
CSERVERS=ON
# compile tools
CTOOLS=ON
# use precompiled headers ( fatest compilation but not optimized if you change headers often )
CSCRIPTPCH=ON
CCOREPCH=ON
# enable/disable extra logs
CEXTRA_LOGS=0

# 从编译中跳过特定模块(需要重新配置cmake)
# use semicolon ; to separate modules
CDISABLED_AC_MODULES=""

# you can add your custom definitions here ( -D )
# example:  CCUSTOMOPTIONS=" -DWITH_PERFTOOLS=ON -DENABLE_EXTRA_LOGS=ON"
#
CCUSTOMOPTIONS="-DENABLE_EXTRAS=1 -DENABLE_EXTRA_LOGS=ON"


##############################################
#
#  DB汇编/导出配置
#
##############################################

#
# 基本上你不需要编辑它
# 但如果你有另一个数据库，你可以添加到这里
# 并在下面创建相对配置
#
DATABASES=(
	"AUTH"
	"CHARACTERS"
	"WORLD"
)

OUTPUT_FOLDER="$AC_PATH_ROOT/env/dist/sql/"

####### BACKUP
# 如果您想在使用db_assembler导入SQL之前备份您的azerothcore数据库，则将其设置为true
# 在此之前不要忘记停止数据库软件(mysql)

BACKUP_ENABLE=false

BACKUP_FOLDER="$AC_PATH_ROOT/env/dist/sql/backup/"

#######

# 完整的数据库
DB_AUTH_PATHS=(
    "$SRCPATH/data/sql/base/db_auth/"
)

DB_CHARACTERS_PATHS=(
    "$SRCPATH/data/sql/base/db_characters"
)

DB_WORLD_PATHS=(
    "$SRCPATH/data/sql/base/db_world/"
)

# UPDATES
DB_AUTH_UPDATES_PATHS=(
    "$SRCPATH/data/sql/updates/db_auth/"
    "$SRCPATH/data/sql/updates/pending_db_auth/"
)

DB_CHARACTERS_UPDATES_PATHS=(
    "$SRCPATH/data/sql/updates/db_characters/"
    "$SRCPATH/data/sql/updates/pending_db_characters/"
)

DB_WORLD_UPDATES_PATHS=(
    "$SRCPATH/data/sql/updates/db_world/"
    "$SRCPATH/data/sql/updates/pending_db_world/"
)

# CUSTOM
DB_AUTH_CUSTOM_PATHS=(
    "$SRCPATH/data/sql/custom/db_auth/"
)

DB_CHARACTERS_CUSTOM_PATHS=(
    "$SRCPATH/data/sql/custom/db_characters/"
)

DB_WORLD_CUSTOM_PATHS=(
    "$SRCPATH/data/sql/custom/db_world/"
)

##############################################
#
#  DB EXPORTER/IMPORTER CONFIGURATIONS
#
##############################################

#
# Skip import of base sql files to avoid
# table dropping
#
DB_SKIP_BASE_IMPORT_IF_EXISTS=true

#
# Example:
#        "C:/Program Files/MySQL/MySQL Server 8.0/bin/mysql.exe"
#        "/usr/bin/mysql"
#        "mysql"
#

DB_MYSQL_EXEC="mysql"
DB_MYSQL_DUMP_EXEC="mysqldump"


DB_AUTH_CONF="MYSQL_USER='root'; \
                    MYSQL_PASS='A112233a!'; \
                    MYSQL_HOST='localhost';\
                    MYSQL_PORT='3310';\
                    "

DB_CHARACTERS_CONF="MYSQL_USER='root'; \
                    MYSQL_PASS='A112233a!'; \
                    MYSQL_HOST='localhost';\
                    MYSQL_PORT='3310';\
                    "

DB_WORLD_CONF="MYSQL_USER='root'; \
                    MYSQL_PASS='A112233a!'; \
                    MYSQL_HOST='localhost';\
                    MYSQL_PORT='3310';\
                    "

DB_AUTH_NAME="auth"

DB_CHARACTERS_NAME="characters"

DB_WORLD_NAME="world"
