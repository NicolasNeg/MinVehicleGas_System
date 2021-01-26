/* Includes */
#include <a_samp>
#include <zcmd>
#include <sscanf2>

#if defined Mensaje
    #undef Mensaje
#endif 

/* Atajos */
#define Mensaje SendClientMessage

/* Variables */
new engine,
    lights,
    alarm,
    doors,
    bonnet,
    boot,
    objective,
    Gasolina[MAX_VEHICLES],
    Motor[MAX_VEHICLES];

new TimerGas[MAX_PLAYERS];

/* Funciones */
forward BajarGasolina(playerid);
public BajarGasolina(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    GameTextForPlayer(playerid, "Debug: -1 litro de gasolina.", 1000, 5);
    Gasolina[vehicleid] --;
    return 1;
}
forward TurnOnVehicle(playerid);
public TurnOnVehicle(playerid)
{
    new vehiculoid = GetPlayerVehicleID(playerid);
    if(Motor[vehiculoid] == 0)
    {
        GetVehicleParamsEx(vehiculoid,engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehiculoid, 1, lights, alarm, doors, bonnet, boot, objective);
        Motor[vehiculoid] = 1;
        GameTextForPlayer(playerid,"~g~~h~Vehiculo encendido",1000,3);
        TimerGas[playerid] = SetTimerEx("BajarGasolina", 180000, true, "d", playerid);
    }
    else 
    {
        GetVehicleParamsEx(vehiculoid,engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehiculoid, 0, lights, alarm, doors, bonnet, boot, objective);
        Motor[vehiculoid] = 0;
        GameTextForPlayer(playerid,"~g~~h~Vehiculo Apagado",1000,3);
        KillTimer(TimerGas[playerid]);
    }
    return 1;
}

/* Publics */
public OnFilterScriptInit()
{
    print("\n------------------------------------------");
    print("MiniGasVehicle System cargado...");
    print("--------------------------------------------\n");
    ManualVehicleEngineAndLights();
    return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
    KillTimer(TimerGas[playerid]);
    return 1;
}
CMD:motor(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Mensaje(playerid, -1, "No estas conduciendo el vehiculo!");
        SetTimerEx("TurnOnVehicle",3000, false,"i",playerid);
    }
    return 1;
}
CMD:dargasolina(playerid, params[])
{
    new vehid, cantidad;
    if(sscanf(params,"ii", vehid,cantidad)) return Mensaje(playerid,-1,"USO: /dargasolina [vehid] [cantidad]");
    if(cantidad > 100) return Mensaje(playerid,-1,"No puedes dar mas de 100 litros de gasolina.");
    Gasolina[vehid] = cantidad;
    new mensaje[64];
    format(mensaje,sizeof(mensaje),"[Info]: Le agregaste %i litros de gasolina a el veh: %i",cantidad, vehid);
    Mensaje(playerid,-1,mensaje);
    return 1;
}
CMD:chequear(playerid)
{
    new mensaje[144];
    new vehicleid = GetPlayerVehicleID(playerid);
    format(mensaje,sizeof(mensaje),"[Info]: Tu vehiculo tiene: %d litros de gasolina.",Gasolina[vehicleid]);
    return 1;
}
