# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore
## XP Weekend module
- Latest build status with azerothcore: [![Build Status](https://github.com/azerothcore/mod-weekend-xp/workflows/core-build/badge.svg?branch=master&event=push)](https://github.com/azerothcore/mod-weekend-xp)



## Description

This module is a xp module that will allow the server owner/host to select how much XP players can recieve on the weekend via a config file.


## How to use ingame

应用模块并在周末登录，在登录时您将看到一个通知，以查看模块是否已被激活。

## Requirements

My new module requires:

- AzerothCore v1.0.1+


## Installation

```
1) 只需将模块放在艾泽拉斯核心源代码的“modules”目录下。 
2) 手动导入SQL到正确的数据库(auth、world或characters)或使用' db_assembler.sh”(如果“include.sh”提供)。
3) 重新运行cmake并启动一个干净的艾泽拉斯核心版本。
```

## Edit module configuration (optional)

如果您需要更改模块配置，去到你的服务器的配置文件夹（你worldserver或者worldserver.exe是），复制mod-double-xp-weekend.conf.dist到mod-double-xp-weekend.conf和编辑新的文件。


## Credits

* [Me](https://github.com/Talamortis) (author of the module)

AzerothCore: [repository](https://github.com/azerothcore) - [website](http://azerothcore.org/) - [discord chat community](https://discord.gg/PaqQRkd)
