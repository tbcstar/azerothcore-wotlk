CREATE TABLE IF NOT EXISTS `mod_weapon_visual_effect` (
    `item_guid` INT(10) UNSIGNED NOT NULL,
    `enchant_visual_id` INT(10) UNSIGNED NOT NULL,
    PRIMARY KEY(`item_guid`))
    COMMENT = '储存mod武器视觉效果的附魔id'
    DEFAULT CHARSET = utf8
    ENGINE = InnoDB;
