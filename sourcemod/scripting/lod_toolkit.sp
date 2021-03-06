#include <sourcemod>
#include <sdktools>

const MAX_PLAYER_IDS = 32

public Plugin:myinfo =
{
    name = "Legends of Dota Toolkit",
    description = "Allows the use of bots, as well as other server commands",
    author = "Ash47",
    version = "1.0.0",
    url = "https://github.com/ash47/LegendsOfDota"
};

public OnPluginStart()
{
    RegServerCmd("clear_playerid", clear_playerid);
    RegServerCmd("read_playerid", read_playerid);
    RegServerCmd("set_playerid", set_playerid);
    RegServerCmd("sm_gmode", changeGamemode);

    //RegConsoleCmd("sm_radiant", sm_radiant , "Sets your team to radiant")
    //RegConsoleCmd("sm_dire", sm_dire , "Sets your team to dire")
}

public Action:changeGamemode(argc)
{
    if(argc != 1)
    {
        PrintToServer("sm_gmode <gamemodeID>")
    }

    decl String:arg[128];
    decl String:full[256];
    GetCmdArgString(full, 256);
    GetCmdArg(1, arg, 128);
    new gmode = StringToInt(arg, 10);
    GameRules_SetProp("m_iGameMode", gmode, 4, 0, false);
    return Action:0;
}

public Action:sm_radiant(client, args)
{
    ChangeClientTeam(client, 2)

    return Plugin_Handled
}

public Action:sm_dire(client, args)
{
    ChangeClientTeam(client, 3)

    return Plugin_Handled
}

public Action:clear_playerid(argc)
{
    if (argc != 1)
    {
        PrintToServer("clear_playerid <playerid>")
        return Plugin_Handled
    }

    new String:buffer[32]
    GetCmdArg(1, buffer, sizeof(buffer))

    PrintToServer("clearing player: ")
    PrintToServer(buffer)

    new playerId = StringToInt(buffer)
    if (playerId < 0 || playerId >= MAX_PLAYER_IDS)
    {
        PrintToServer("clear_playerid <playerid>")
        return Plugin_Handled
    }

    new ent = GetPlayerResourceEntity()
    new offs = FindSendPropInfo("CDOTA_PlayerResource", "m_iPlayerSteamIDs")

    SetEntData(ent, offs + 8*playerId, 0, 4, true)
    SetEntData(ent, offs + 8*playerId + 4, 0, 4, true)

    return Plugin_Handled
}

public Action:read_playerid(argc)
{
    if (argc != 1)
    {
        PrintToServer("read_playerid <playerid>")
        return Plugin_Handled
    }

    new String:buffer[32]
    GetCmdArg(1, buffer, sizeof(buffer))

    PrintToServer("reading player %s", buffer)

    new playerId = StringToInt(buffer)
    if (playerId < 0 || playerId >= MAX_PLAYER_IDS)
    {
        PrintToServer("clear_playerid <playerid>")
        return Plugin_Handled
    }

    new ent = GetPlayerResourceEntity()
    new offs = FindSendPropInfo("CDOTA_PlayerResource", "m_iPlayerSteamIDs")

    PrintToServer("values = %i %i", GetEntData(ent, offs + 8*playerId, 4), SetEntData(ent, offs + 8*playerId + 4, 4))

    return Plugin_Handled
}

public Action:set_playerid(argc)
{
    if (argc != 2)
    {
        PrintToServer("set_playerid <playerid> <steamid32>")
        return Plugin_Handled
    }

    new String:buffer[32]
    GetCmdArg(1, buffer, sizeof(buffer))

    new String:buffer2[32]
    GetCmdArg(2, buffer2, sizeof(buffer2))
    new steamID = StringToInt(buffer2)

    PrintToServer("Setting player %s %i", buffer, steamID)

    new playerId = StringToInt(buffer)
    if (playerId < 0 || playerId >= MAX_PLAYER_IDS)
    {
        PrintToServer("clear_playerid <playerid>")
        return Plugin_Handled
    }

    new ent = GetPlayerResourceEntity()
    new offs = FindSendPropInfo("CDOTA_PlayerResource", "m_iPlayerSteamIDs")

    SetEntData(ent, offs + 8*playerId, steamID, 4, true)
    SetEntData(ent, offs + 8*playerId + 4, 1, 4, true)

    return Plugin_Handled
}