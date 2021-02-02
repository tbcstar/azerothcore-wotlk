//by SymbolixDEV
//Reworked by Talamortis
#include "ScriptMgr.h"
#include "Config.h"
#include <Player.h>
#include "Group.h"
#include "GroupMgr.h"
#include "InstanceScript.h"
#include "Chat.h"

static bool removeAura, BossAnnouncerEnable, BossAnnounceToPlayerOnLogin;

class Boss_Announcer : public PlayerScript
{
public:
	Boss_Announcer() : PlayerScript("Boss_Announcer") {}

    void OnLogin(Player *player)
    {
        if (BossAnnouncerEnable)
        {
            if (BossAnnounceToPlayerOnLogin)
            {
                ChatHandler(player->GetSession()).SendSysMessage("服务器已启用 |cff4CFF00Boss公告 |r模块。");
            }
        }
    }

    void OnCreatureKill(Player* player, Creature* boss)
    {
        if (BossAnnouncerEnable)
        {
            if (boss->GetMap()->IsRaid() && boss->getLevel() > 80 && boss->IsDungeonBoss())
            {
                //lets get the info we want
                Map* map = player->GetMap();
                std::string p_name;
                std::string g_name;
                std::string boss_name = boss->GetName();
                std::string IsHeroicMode;
                std::string IsNormal;
                std::string tag_colour = "7bbef7";
                std::string plr_colour = "7bbef7";
                std::string guild_colour = "00ff00";
                std::string boss_colour = "ff0000";
                std::string alive_text = "00ff00";
                uint32 Alive_players = 0;
                uint32 Tanks = 0;
                uint32 Healers = 0;
                uint32 DPS = 0;
                Map::PlayerList const & playerlist = map->GetPlayers();

                if (!player->GetGroup())
                    p_name = player->GetName();
                else
                    p_name = player->GetGroup()->GetLeaderName();

                if (player->GetMap()->Is25ManRaid())
                    IsNormal = "25";
                else
                    IsNormal = "10";

                if (player->GetMap()->IsHeroic())
                    IsHeroicMode = "|cffff0000英雄|r";
                else
                    IsHeroicMode = "|cff00ff00普通|r";

                std::ostringstream stream;

                for (Map::PlayerList::const_iterator itr = playerlist.begin(); itr != playerlist.end(); ++itr)
                {
                    if (!itr->GetSource())
                        continue;

                    if (itr->GetSource()->IsAlive())
                        Alive_players++;

                    if (itr->GetSource()->HasHealSpec())
                        Healers++;
                    else if (itr->GetSource()->HasTankSpec())
                        Tanks++;
                    else
                        DPS++;

                    if (removeAura == true)
                    {
                        uint32 buff = itr->GetSource()->GetTeamId() == TEAM_ALLIANCE ? 57723 : 57724;

                        if (itr->GetSource()->HasAura(buff))
                            itr->GetSource()->RemoveAura(buff);
                    }

                    if (!player->GetGuild())
                    {
                        // if we are in group lets get guild of the leader
                        if (player->GetGroup() && itr->GetSource()->GetGroup()->IsLeader(itr->GetSource()->GetGUID())) {
                            if (!itr->GetSource()->GetGuild()) {
                                g_name = "< 没有公会 >";
                            } else {
                                g_name = itr->GetSource()->GetGuildName();
                            }
                        }

                        g_name = "< 没有公会 >";
                    }
                    else
                        g_name = player->GetGuildName();
                }

                stream << "|CFF" << tag_colour << "|r|cff" << plr_colour << " " << p_name << "|r's 公会 |cff" << guild_colour << "" << g_name << "|r 已经被杀 |CFF" << boss_colour << "[" << boss_name << "]|r 剩余 |cff" << alive_text << "" << Alive_players << " /" << IsNormal << "|r 存活玩家 " << IsHeroicMode << " 模式， 团队 |cff" << tag_colour << "坦克: " << Tanks  <<"|r |cff" << guild_colour <<
                    " 治疗: "<< Healers << "|r |cff" << boss_colour << " DPS: " << DPS << "|r";
                sWorld->SendServerMessage(SERVER_MSG_STRING, stream.str().c_str());


            }
        }
    }
};

class Boss_Announcer_World : public WorldScript
{
public:
	Boss_Announcer_World() : WorldScript("Boss_Announcer_World") { }

	void OnBeforeConfigLoad(bool reload) override
	{
		if (!reload) {
			std::string conf_path = _CONF_DIR;
			std::string cfg_file = conf_path + "/mod_boss_announcer.conf";
#ifdef WIN32
			cfg_file = "mod_boss_announcer.conf";
#endif
			std::string cfg_def_file = cfg_file + ".dist";
			sConfigMgr->LoadMore(cfg_def_file.c_str());

			sConfigMgr->LoadMore(cfg_file.c_str());
            SetInitialWorldSettings();
		}
	}
    void  SetInitialWorldSettings()
    {
        removeAura = sConfigMgr->GetBoolDefault("Boss.Announcer.RemoveAuraUponKill", false);
        BossAnnouncerEnable = sConfigMgr->GetBoolDefault("Boss.Announcer.Enable", true);
        BossAnnounceToPlayerOnLogin = sConfigMgr->GetBoolDefault("Boss.Announcer.Announce", true);
    }
};

void AddBoss_AnnouncerScripts()
{
	new Boss_Announcer_World;
	new Boss_Announcer;
}
