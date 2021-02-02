# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore
## Azerothcore Detailed Logging Module
- Latest build status with azerothcore: [![Build Status](https://github.com/azerothcore/mod-detailed-logging/workflows/core-build/badge.svg?branch=master&event=push)](https://github.com/azerothcore/mod-detailed-logging)

详细的日志记录模块将为某些事件（死亡，死亡，移动）提供额外的日志记录，这将有助于通过以下活动促进将来的模块和应用程序：

  - 数据挖掘
  - 机器学习
  - 统计反馈

### 用法

  - 一旦将此模块添加到AzerothCore并进行配置，您将看到三个新的日志文件添加到bin文件夹中：kills.log，deaths.log和zonearea.log
  - 除了增强的日志记录之外，此模块不提供其他功能。需要使用其他模块，应用程序或代码来创建任何其他实用程序。

### 文件描述

| 文档名称        | 描述           |
| ------------- |----------------| 
| kills.log      | 每当生物被玩家或其宠物/图腾杀死时，kills.log将记录生命统计数据 |
| deaths.log     | 每当玩家被生物杀死时，Deaths.log都会记录生命统计数据      |
| zonearea.log | 每当玩家移至新区域和/或区域时，zonearea.log都会记录生命统计数据      |