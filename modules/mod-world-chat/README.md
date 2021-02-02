# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore
## World Chat
- Latest build status with azerothcore: [![Build Status](https://github.com/azerothcore/mod-world-chat/workflows/core-build/badge.svg?branch=master&event=push)](https://github.com/azerothcore/mod-world-chat)

# Description
世界聊天模块是AzerothCore的简单全局聊天（派系或跨派）。

# Functionality
* 怎么聊天？
    - .chat Message - 适用于所有人，GM和玩家。
    - /join 像普通聊天中一样聊天并聊天（此名称根据配置文件而异）

* 如果禁用跨派系，GM如何向其他派系聊天发送消息？
    - 使用.chat命令，后跟该派系的首字母（例如：对于部落，请使用.chath）
    
* 如何按GM状态显示或隐藏？
    - 您可以通过打开.gm chat和.gm on来显示GM或DEV状态。如果您用.dev on上也可以显示为DEV

# Commands
功能齐全的命令列表：
* .chat <$TEXT>
  - 用于世界聊天的命令
* .chat on
  - 用于启用世界聊天
* .chat off
  - 用于禁用世界聊天
* .chata <$TEXT>
  - 用于与GM与联盟派系进行对话（因此，在跨派世界聊天被禁用时，您可以与另一派系进行对话）
* .chath <$TEXT>
  - 过去曾与GM争夺部落派系交谈（因此在跨派世界聊天被禁用时，您可以与其他派系交谈）
  
# Installation
## Core Setup

To add the module follow the next steps:
1. Go into the folder <source_of_335>/modules
2. Clone the repository here.

On windows, open git bash and paste this command:
```
git clone https://github.com/wizzymore/mod_world_chat.git
```
On linux:

```
git clone https://github.com/wizzymore/mod_world_chat.git
```

## Database Setup
### Setting up commands
Open DB-Assembler and use the option 8) Import-customs

OR

Run the following sql file in your database: [this](/sql/world/command.sql)



## Server Config Setup
### On Windows
Modify the config : "WorldChat.conf" by your needs.
Edit the settings in the .conf file but keep both!

### On Linux
Navigate to /etc/ folder from your azeroth build files and execute this command:
```bash
cp WorldChat.conf.dist WorldChat.conf
```
Modify the config : "WorldChat.conf" by your needs.
Edit the settings in the .conf file but keep both!
## Start the server and enjoy
Done, you are ready to use the World Chat System! Go online and try it out!
