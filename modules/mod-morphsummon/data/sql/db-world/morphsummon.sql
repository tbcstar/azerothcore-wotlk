-- mod-morphsummon

SET @ENTRY           := 601072;
SET @MODELID         := 15665;               -- 高级军士格里姆斯福德(生物ID 15703，不再使用)
SET @NAME            := '凯瑞斯语';
SET @SUBNAME         := '召唤形态学家';
SET @SCRIPTNAME      := 'npc_morphsummon';
SET @NPC_TEXT_HELLO  := @ENTRY;
SET @NPC_TEXT_SORRY  := @NPC_TEXT_HELLO + 1;
SET @NPC_TEXT_CHOICE := @NPC_TEXT_HELLO + 2;
SET @MENU_HELLO      := 61072;
SET @MENU_SORRY      := @MENU_HELLO + 1;
SET @MENU_CHOICE     := @MENU_HELLO + 2;

DELETE FROM `creature_template` WHERE `entry` = @ENTRY;
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `mindmg`, `maxdmg`, `dmgschool`, `attackpower`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `minrangedmg`, `maxrangedmg`, `rangedattackpower`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`, `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`, `spell5`, `spell6`, `spell7`, `spell8`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`, `VerifiedBuild`)
VALUES
(@ENTRY,0,0,0,0,0,@MODELID,0,0,0,@NAME,@SUBNAME,NULL,0,80,80,2,35,1,1,1.14286,1,0,0,0,0,0,1,2000,2000,8,0,2048,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,3,1,1,1,1,0,0,1,0,2,@SCRIPTNAME,0);

DELETE FROM `npc_text` WHERE `ID` IN (@NPC_TEXT_HELLO,@NPC_TEXT_SORRY,@NPC_TEXT_CHOICE);
INSERT INTO `npc_text` (`ID`, `text0_0`)
VALUES
(@NPC_TEXT_HELLO, '你好， $N，如果你正在寻找改变你的召唤生物外观的方法，我可以帮助你。'),
(@NPC_TEXT_SORRY, '你好， $N，我很抱歉，但是你没有我可以变形的召唤生物。'),
(@NPC_TEXT_CHOICE, '请选择:');

DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (@MENU_HELLO,@MENU_SORRY,@MENU_CHOICE);
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`)
VALUES
(@MENU_HELLO,0,0,'选择变形',0,0,0,0,0,0,0,'',0,0),
(@MENU_HELLO,1,0,'选择恶魔守卫的武器',0,0,0,0,0,0,0,'',0,0),
(@MENU_SORRY,0,0,'啊,别介意。',0,0,0,0,0,0,0,'',0,0),
(@MENU_CHOICE,0,0,'返回..',0,0,0,0,0,0,0,'',0,0),
(@MENU_CHOICE,1,4,'下一个..',0,0,0,0,0,0,0,'',0,0),
(@MENU_CHOICE,2,4,'前一个..',0,0,0,0,0,0,0,'',0,0);
