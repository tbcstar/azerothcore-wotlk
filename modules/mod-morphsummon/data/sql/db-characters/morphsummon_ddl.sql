CREATE TABLE IF NOT EXISTS `mod_morphsummon_felguard_weapon` (
  `PlayerGUIDLow` int(10) unsigned NOT NULL,
  `FelguardItemID` int(10) unsigned NOT NULL COMMENT '恶魔守卫虚拟物品插槽0的物品ID',
  PRIMARY KEY (`PlayerGUIDLow`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='mod-morphsummon; 用于定制恶魔守卫武器';
