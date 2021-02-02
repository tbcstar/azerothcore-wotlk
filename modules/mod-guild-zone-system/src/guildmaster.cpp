#include "Player.h"
#include "ScriptMgr.h"
#include "World.h"
#include "DatabaseEnv.h"
#include "ScriptedGossip.h"

#define MSG_GOSSIP_TELE          "传送到公会领地"
#define MSG_GOSSIP_BUY           "购买公会领地 (1000 金币)"
#define MSG_GOSSIP_SELL          "出售公会领地 (500 金币)"
#define MSG_GOSSIP_NEXTPAGE      "下一步 -->"
#define MSG_INCOMBAT             "你处于战斗状态，不能被传送到你的公会领地。"
#define MSG_NOGUILDHOUSE         "你的公会目前还没有公会领地。"
#define MSG_NOFREEGH             "不幸的是，所有的公会领地都在使用。"
#define MSG_ALREADYHAVEGH        "抱歉，但你已经拥有一个公会领地(%s)。"
#define MSG_NOTENOUGHMONEY       "你没有购买公会领地所需要的%u金币。"
#define MSG_GHOCCUPIED           "这个公会领地目前还在使用中，不能购买。"
#define MSG_CONGRATULATIONS      "恭喜你!你成功购买了一个公会领地。"
#define MSG_SOLD                 "你卖掉了你的公会领地并获得了500金币。"
#define MSG_NOTINGUILD           "在使用公会领地之前，你必须先进入公会领地。"
#define MSG_SELL_CONFIRM         "你确定你想以买入价格的一半卖掉你的公会领地吗?"

#define OFFSET_GH_ID_TO_ACTION 1500
#define OFFSET_SHOWBUY_FROM 10000

#define ACTION_TELE 1001
#define ACTION_SHOW_BUYLIST 1002 //deprecated. Use (OFFSET_SHOWBUY_FROM + 0) instead
#define ACTION_SELL_GUILDHOUSE 1003

#define ICON_GOSSIP_BALOON 0
#define ICON_GOSSIP_WING 2
#define ICON_GOSSIP_BOOK 3
#define ICON_GOSSIP_WHEEL1 4
#define ICON_GOSSIP_WHEEL2 5
#define ICON_GOSSIP_GOLD 6
#define ICON_GOSSIP_BALOONDOTS 7
#define ICON_GOSSIP_TABARD 8
#define ICON_GOSSIP_XSWORDS 9

#define COST_GH_BUY 1000 //1000 g.
#define COST_GH_SELL 500 //500 g.

#define GOSSIP_COUNT_MAX 10

class guildmaster : public CreatureScript
{
public:
    guildmaster() : CreatureScript("guildmaster") { }

    bool isPlayerGuildLeader(Player *player)
    {
        return (player->GetRank() == 0) && (player->GetGuildId() != 0);
    }

    bool getGuildHouseCoords(uint32 guildId, float &x, float &y, float &z, uint32 &map)
    {
        if (guildId == 0) //if player has no guild
            return false;

        QueryResult result;
        result = WorldDatabase.PQuery("SELECT `x`, `y`, `z`, `map` FROM `guildhouses` WHERE `guildId` = %u", guildId);
        if (result)
        {
            Field *fields = result->Fetch();
            x = fields[0].GetFloat();
            y = fields[1].GetFloat();
            z = fields[2].GetFloat();
            map = fields[3].GetUInt32();
            return true;
        }
        return false;
    }

    void teleportPlayerToGuildHouse(Player *player, Creature *_creature)
    {
        if (player->IsInCombat()) //don't allow teleporting while in combat
        {
            _creature->MonsterWhisper(MSG_INCOMBAT, player);
            return;
        }

        float x, y, z;
        uint32 map;

        if (getGuildHouseCoords(player->GetGuildId(), x, y, z, map))
            player->TeleportTo(map, x, y, z, 0.0f);
        else
            _creature->MonsterWhisper(MSG_NOGUILDHOUSE, player);
    }

    bool showBuyList(Player *player, Creature *_creature, uint32 showFromId = 0)
    {
        //show not occupied guildhouses
        QueryResult result;
        result = WorldDatabase.PQuery("SELECT `id`, `comment` FROM `guildhouses` WHERE `guildId` = 0 AND `id` > %u ORDER BY `id` ASC LIMIT %u", showFromId, GOSSIP_COUNT_MAX);

        if (result)
        {
            uint32 guildhouseId = 0;
            std::string comment = "";
            do
            {
                Field *fields = result->Fetch();
                guildhouseId = fields[0].GetInt32();
                comment = fields[1].GetString();
                //send comment as a gossip item
                //transmit guildhouseId in Action variable
                player->ADD_GOSSIP_ITEM(ICON_GOSSIP_TABARD, comment, GOSSIP_SENDER_MAIN, guildhouseId + OFFSET_GH_ID_TO_ACTION);
            } while (result->NextRow());

            if (result->GetRowCount() == GOSSIP_COUNT_MAX)
            {
                //assume that we have additional page
                //add link to next GOSSIP_COUNT_MAX items
                player->ADD_GOSSIP_ITEM(ICON_GOSSIP_BALOONDOTS, MSG_GOSSIP_NEXTPAGE, GOSSIP_SENDER_MAIN, guildhouseId + OFFSET_SHOWBUY_FROM);
            }
            player->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, _creature->GetGUID());
            return true;
        }
        else if (!result)
        {
            //all guildhouses are occupied
            _creature->MonsterWhisper(MSG_NOFREEGH, player);
            player->CLOSE_GOSSIP_MENU();
        }
        else
            //this condition occurs when COUNT(guildhouses) % GOSSIP_COUNT_MAX == 0
            //just show GHs from beginning
            showBuyList(player, _creature, 0);
        return false;
    }

    bool isPlayerHasGuildhouse(Player *player, Creature *_creature, bool whisper = false)
    {
        QueryResult result;
        result = WorldDatabase.PQuery("SELECT `comment` FROM `guildhouses` WHERE `guildId` = %u",
            player->GetGuildId());

        if (result)
        {
            if (whisper)
            {
                Field *fields = result->Fetch();
                char msg[100];
                sprintf(msg, MSG_ALREADYHAVEGH, fields[0].GetCString());
                _creature->MonsterWhisper(msg, player);
            }
            return true;
        }
        return false;
    }

    void buyGuildhouse(Player *player, Creature *_creature, uint32 guildhouseId)
    {

        if (player->GetMoney() < COST_GH_BUY)
        {
            //show how much money player need to buy GH (in gold)
            char msg[100];
            sprintf(msg, MSG_NOTENOUGHMONEY, COST_GH_BUY);
            _creature->MonsterWhisper(msg, player);
            return;
        }

        if (isPlayerHasGuildhouse(player, _creature, true))
        {
            return;
        }

        QueryResult result;
        //check if somebody already occupied this GH
        result = WorldDatabase.PQuery("SELECT `id` FROM `guildhouses` WHERE `id` = %u AND `guildId` <> 0", guildhouseId);

        if (result)
        {
            _creature->MonsterWhisper(MSG_GHOCCUPIED, player);
            return;
        }
        //update DB
        result = WorldDatabase.PQuery("UPDATE `guildhouses` SET `guildId` = %u WHERE `id` = %u",
            player->GetGuildId(), guildhouseId);
        player->ModifyMoney(-10000000);
        //player->DestroyItemCount(token, cost, true);
        _creature->MonsterWhisper(MSG_CONGRATULATIONS, player);
    }

    void sellGuildhouse(Player *player, Creature *_creature)
    {
        if (isPlayerHasGuildhouse(player, _creature))
        {
            QueryResult result;
            result = WorldDatabase.PQuery("UPDATE `guildhouses` SET `guildId` = 0 WHERE `guildId` = %u",
                player->GetGuildId());
            player->ModifyMoney(5000000);
            char msg[100];
            sprintf(msg, MSG_SOLD);
            _creature->MonsterWhisper(msg, player);
        }
    }

    bool OnGossipSelect(Player *player, Creature *_creature, uint32 sender, uint32 action)
    {
        player->PlayerTalkClass->ClearMenus();
        if (sender != GOSSIP_SENDER_MAIN)
            return false;

        switch (action)
        {
        case ACTION_TELE:
            player->CLOSE_GOSSIP_MENU();
            teleportPlayerToGuildHouse(player, _creature);
            break;
        case ACTION_SHOW_BUYLIST:
            showBuyList(player, _creature);
            break;
        case ACTION_SELL_GUILDHOUSE:
            sellGuildhouse(player, _creature);
            player->CLOSE_GOSSIP_MENU();
            break;
        default:
            if (action > OFFSET_SHOWBUY_FROM)
            {
                showBuyList(player, _creature, action - OFFSET_SHOWBUY_FROM);
            }
            else if (action > OFFSET_GH_ID_TO_ACTION)
            {
                player->CLOSE_GOSSIP_MENU();
                buyGuildhouse(player, _creature, action - OFFSET_GH_ID_TO_ACTION);
            }
            break;
        }
        return true;
    }

    bool OnGossipHello(Player *player, Creature *_creature)
    {
        if (player->GetGuildId() == 0)
        {
            _creature->MonsterWhisper(MSG_NOTINGUILD, player);
            player->CLOSE_GOSSIP_MENU();
            return true;
        }
        player->ADD_GOSSIP_ITEM(ICON_GOSSIP_BALOON, MSG_GOSSIP_TELE, GOSSIP_SENDER_MAIN, ACTION_TELE);

        if (isPlayerGuildLeader(player))
        {
            if (isPlayerHasGuildhouse(player, _creature))
            {
                player->ADD_GOSSIP_ITEM_EXTENDED(ICON_GOSSIP_GOLD, MSG_GOSSIP_SELL, GOSSIP_SENDER_MAIN, ACTION_SELL_GUILDHOUSE, MSG_SELL_CONFIRM, 0, false);
            }
            else
            {
                player->ADD_GOSSIP_ITEM(ICON_GOSSIP_GOLD, MSG_GOSSIP_BUY, GOSSIP_SENDER_MAIN, ACTION_SHOW_BUYLIST);
            }
        }

        player->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, _creature->GetGUID());
        return true;
    }
};

void AddSC_guildmaster()
{
    new guildmaster();
}
