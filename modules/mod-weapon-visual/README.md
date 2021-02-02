# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore
## mod-weapon-visual
### This is a module for [AzerothCore](http://www.azerothcore.org)
- Latest build status with azerothcore: [![Build Status](https://github.com/azerothcore/mod-weapon-visual/workflows/core-build/badge.svg?branch=master&event=push)](https://github.com/azerothcore/mod-weapon-visual)

## 重要笔记

果使用此模块的旧版本，请使用以下SQL语句更新表结构：
```sql
ALTER TABLE `custom_item_enchant_visuals`
CHANGE `iguid` `item_guid` int(10) unsigned NOT NULL COMMENT 'item DB guid' FIRST,
CHANGE `display` `enchant_visual_id` int(10) unsigned NOT NULL COMMENT 'enchantID' AFTER `item_guid`,
DROP `PlayerName`,
RENAME TO `mod_weapon_visual_effect`,
COMMENT='Stores the enchant IDs for the visuals of mod-weapon-visual';
```

## 描述
- 角色服务：为武器添加视觉效果

### How to install
1. 只需将模块放在modulesAzerothCore源文件夹的文件夹下即可。
2. 重新运行cmake并启动AzerothCore的全新构建
3. 导入 `sql/world/base/creature_template.sql` 到 world DB.
4. 导入 `sql/characters/base/mod_weapon_visual_effect.sql` 到 characters DB.
5. 登录游戏， 生成 Npc ID 55003, Enjoy.

### Usage
- Enable this module and talk with the assigned creature :D

### Showcase / Video 
- [Video Here!](https://youtu.be/Sat9KWvsPwQ)


## Credits
* [Poszer](https://github.com/Poszer): (Author of the module): 
* [Talamortis](https://github.com/Talamortis):  (Database implementation, code review & General support):
* [Micrah/Milestorme](https://github.com/milestorme): (Thanks for the help with the Module creation & General support): 

AzerothCore: [repository](https://github.com/azerothcore) - [website](http://azerothcore.org/) - [discord chat community](https://discord.gg/PaqQRkd)
