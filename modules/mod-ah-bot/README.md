# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore
## Mod-AHBOT
- Latest build status with azerothcore: [![Build Status](https://github.com/azerothcore/mod-ah-bot/workflows/core-build/badge.svg?branch=master&event=push)](https://github.com/azerothcore/mod-ah-bot)


## Important notes

You have to use at least AzerothCore commit [9adba48](https://github.com/azerothcore/azerothcore-wotlk/commit/9adba482c236f1087d66a672e97a99f763ba74b3).

If you use an old version of this module please update the table structure using this SQL statement:

```sql
ALTER TABLE `auctionhousebot` RENAME TO `mod_auctionhousebot`;
```

## Description

An auction house bot for the best core: AzerothCore.

## Installation

```
1. Simply place the module under the `modules` directory of your AzerothCore source. 
1. Import the SQL manually to the right Database (auth, world or characters) or with the `db_assembler.sh` (if `include.sh` provided).
1. Re-run cmake and launch a clean build of AzerothCore.
```

## Edit module configuration (optional)

If you need to change the module configuration, go to your server configuration folder (where your `worldserver` or `worldserver.exe` is)
rename the file mod_ahbot.conf.dist to mod_ahbot.conf and edit it.

## 用法

编辑模块配置，并添加玩家帐户ID和角色ID。这个角色会在拍卖行买卖物品，因此请给他起个好名字。

Notes:
- 所使用的帐户不需要任何安全级别，并且可以是玩家帐户。
- ahbot所使用的角色并不是在游戏中使用的。如果你用它来浏览拍卖行，你可能会遇到“正在搜索物品……”这样的问题。

## Credits

- Ayase: ported the bot to AzerothCore
- Other contributors (check the contributors list)

