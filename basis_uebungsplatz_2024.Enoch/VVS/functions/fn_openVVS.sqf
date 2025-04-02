/*
	File: fn_openVVS.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Opens the VVS menu and fills in the blanks.
*/
params["_sp","_cfg"];
if(_cfg == "") then
{
	if(_sp == "") exitWith {closeDialog 0};
	VVS_SP = _sp;
}
	else
{
	if(count _sp == 0) exitWith {closeDialog 0;};
	VVS_SP = _sp;
	VVS_Cfg = _cfg;
};
disableSerialization;
if(!(createDialog "VVS_Menu")) exitWith {}; //Couldn't create the menu