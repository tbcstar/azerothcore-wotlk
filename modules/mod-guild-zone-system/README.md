# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore
## mod-guild-zone-system
### This is a module for [AzerothCore](http://www.azerothcore.org)
- Latest build status with azerothcore: [![Build Status](https://github.com/azerothcore/mod-guild-zone-system/workflows/core-build/badge.svg?branch=master&event=push)](https://github.com/azerothcore/mod-guild-zone-system)

### 特征:
- 允许公会大师购买/出售区域。
- 购买后，公会大师和公会成员可以移植到您为该区域设置的指定公会房屋位置。


### This module currently requires:
- AzerothCore v1.0.1+


### How to install
1. Simply place the module under the `modules` folder of your AzerothCore source folder.
2. Re-run cmake and launch a clean build of AzerothCore
3. Navigate to `modules`, apply the SQL files in the correct databases.


### 用法
- Spawn NPC ID 55005 `.npc a 55005`
- 创建一个公会 `.guild create MyCharacter "MyGuild"`
- 和NPC对话


### 卸载

要删除SQL，请在world数据库中使用以下查询
```SQL
-- The example of the creature --
DELETE FROM `creature_template` WHERE entry=55005;

-- All creatures for guild houses --
DELETE FROM `creature` WHERE id=55005;

DROP TABLE `guildhouses`;
```


### Credits
* Bloodication: Original author *probably* 
* Poszer: Port into a module 

AzerothCore: [repository](https://github.com/azerothcore) - [website](http://azerothcore.org/) - [discord chat community](https://discord.gg/PaqQRkd)
<!-- - Latest build status with azerothcore: [![Build Status](https://travis-ci.org/azerothcore/mod-guildhouse-system.svg?branch=master)](https://travis-ci.org/azerothcore/mod-guildhouse-system) -->
