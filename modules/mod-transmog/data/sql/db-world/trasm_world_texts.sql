SET @TEXT_ID := 601083;
DELETE FROM `npc_text` WHERE `ID` IN  (@TEXT_ID,@TEXT_ID+1);
INSERT INTO `npc_text` (`ID`, `text0_0`) VALUES
(@TEXT_ID, '幻化功能允许你在不改变物品属性的情况下改变物品的外观。\r\n在幻化中使用的物品将和你绑定而且无法交易。\r\n刷新菜单会更新效果和价格。\r\n\r\n不是所有的东西都可以互相幻化。\r\n限制包括但不限于:\r\n只有盔甲和武器可以被幻化\r\n枪、弓和十字弓可以相互幻化\r\n鱼竿不能幻化\r\n你必须能够装备和使用的两种物品。\r\n\r\n只要你保留好你的物品，幻化就会留在物品上。\r\n如果你试图将物品放入公会银行或邮寄给其他人，幻化效果将被剥夺。\r\n\r\n你也可以在幻化师这里免费移除幻化。'),
(@TEXT_ID+1, '您可以保存自己的幻化方案。\r\n\r\n为了保存，你必须首先改变你装备的物品。\r\n然后，当你进入“设置管理”菜单并选择“保存设置”菜单时，\r\n你幻化后的所有物品都会显示出来，这样你就能看到你所保存的物品。\r\n如果您认为该方案是好的，您可以点击保存该方案并按您的意愿命名它。\r\n\r\n要使用方案，可以在“方案管理”菜单中单击已保存的方案，然后选择“使用方案”。\r\n如果该方案具有已被幻化的物品的幻化，则旧的幻化将丢失。\r\n请注意，当尝试使用一个幻化方案时，与正常幻化时适用相同的幻化限制。\r\n\r\n要删除方案，您可以进入方案的菜单并选择“删除方案”。');

SET @STRING_ENTRY := 11100;
DELETE FROM `acore_string` WHERE `entry` IN  (@STRING_ENTRY+0,@STRING_ENTRY+1,@STRING_ENTRY+2,@STRING_ENTRY+3,@STRING_ENTRY+4,@STRING_ENTRY+5,@STRING_ENTRY+6,@STRING_ENTRY+7,@STRING_ENTRY+8,@STRING_ENTRY+9,@STRING_ENTRY+10);
INSERT INTO `acore_string` (`entry`, `content_default`) VALUES
(@STRING_ENTRY+0, '物品幻化成功。'),
(@STRING_ENTRY+1, '装备槽是空的。'),
(@STRING_ENTRY+2, '选中的幻化物品无效。'),
(@STRING_ENTRY+3, '幻化物品不存在。'),
(@STRING_ENTRY+4, '被幻化物品不存在。'),
(@STRING_ENTRY+5, '所选物品无效。'),
(@STRING_ENTRY+6, '你的钱不够。'),
(@STRING_ENTRY+7, '你没有足够的T币。'),
(@STRING_ENTRY+8, '你所有的幻化都被移除了.'),
(@STRING_ENTRY+9, '没有发现幻化。'),
(@STRING_ENTRY+10, '输入的名字无效。');

