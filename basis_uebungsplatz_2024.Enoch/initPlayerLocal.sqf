//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						Player Initialisierung
//
//------------------------------------------------------------------
//------------------------------------------------------------------
waitUntil{!isNull(player)};
setTerrainGrid 25;
enableEnvironment [false, true];
titleText ["Übungsplatz", "Livonia" ];

// briefingName
[] execVM "scripts\core\briefing.sqf";

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//							Dynamic Groups
//
//------------------------------------------------------------------
//------------------------------------------------------------------

//DynamicGroups_Function Function needs to be initialized on server and client. Clients can then use action TeamSwitch ("U" by default) to access the Dynamic Groups interface.
if (getMissionConfigValue "dynamicGroupsFeat" == "true") then {
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;	//Exec on client
};

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//							Loadouts
//
//------------------------------------------------------------------
//------------------------------------------------------------------
sleep 1;

//Abfrage ob Datenbank oder frisches Loadout
if (getMissionConfigValue "loadPlayers" == "true") then {

	// INIDB
	_clientID = clientOwner;
	_UID = getPlayerUID player;
	_name = name player;
	checkForDatabase = [_clientID, player, _name];
	publicVariableServer "checkForDatabase";
	_hasLoadout = false;

	"loadData" addPublicVariableEventHandler
	{
		_gear = (_this select 1);
		player setUnitLoadout _gear;
		_hasloadout = true;
	};
	
	if (_hasloadout == false) then {
		call compile preprocessFileLineNumbers "loadouts\loadoutInit.sqf";
	};
}
else {
	call compile preprocessFileLineNumbers "loadouts\loadoutInit.sqf";
};

// Loadouts pro Gruppe zuweisen
call compile preprocessFileLineNumbers format ["loadouts\%1\gruppenLoadouts.sqf", fraktionV];

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//							Recolor
//
//------------------------------------------------------------------
//------------------------------------------------------------------

/*
// Recolor Post-Processing - Night
PPeffect_colorC = ppEffectCreate ["ColorCorrections",1500];
PPeffect_colorC ppEffectAdjust [1.04,0.9,-0.00279611,[0.147043,0,0.0476897,-0.34],[1,1,0.94,1.15],[1.39,0.95,-1.34,0]];
PPeffect_colorC ppEffectEnable true;
PPeffect_colorC ppEffectCommit 0;
*/

/*
// Recolor Post-Processing - Desert/Winter
"colorCorrections" ppEffectAdjust 	[1,1,-0.01,[0.0, 0.0, 0.0, 0.0],[1, 0.8, 0.6, 0.6],[0.199, 0.587, 0.114, 0.0]]; 
"colorCorrections" ppEffectEnable true; 
"colorCorrections" ppEffectCommit 0; 
"filmGrain" ppEffectAdjust 	[0.04,1,1,0.1,1,false];      
"filmGrain" ppEffectEnable true;    
*/

/*
// Recolor Post-Processing - Winter Day
"colorCorrections" ppEffectAdjust  [1.1,1.2,-0.01,[0.0, 0.0, 0.0, 0.0],[0.8, 0.8, 1, 0.6],[0.199, 0.587, 0, 0.0]];  
"colorCorrections" ppEffectEnable true;  
"colorCorrections" ppEffectCommit 0; 
"filmGrain" ppEffectAdjust 	[0.04,1,1,0.1,1,false];      
"filmGrain" ppEffectEnable true;
"filmGrain" ppEffectCommit 0;  
*/

/*
// Recolor Post-Processing - brownish, bright african
PPeffect_colorC = ppEffectCreate ["ColorCorrections",1500];
PPeffect_colorC ppEffectAdjust [1,1,-0.00279611,[0.399248,0.452746,0.307538,0.1042],[1.36009,1,0.320698,0.95],[2.50966,0.263398,3.22694,0]];
PPeffect_colorC ppEffectEnable true;
PPeffect_colorC ppEffectCommit 0;
*/

/*
// Recolor Post-Processing - Jungle Rainy
PPeffect_colorC = ppEffectCreate ["ColorCorrections",1500]; 
PPeffect_colorC ppEffectAdjust [1,1,0,[0,1,0.3,0.04],[1,1,1,1],[0.3,0.587,0.114,0]]; 
PPeffect_colorC ppEffectEnable true; 
PPeffect_colorC ppEffectCommit 0;
"filmGrain" ppEffectAdjust  [0.04,1,1,0.1,1,false];
"filmGrain" ppEffectEnable true;
*/

/*
// Recolor Post-Processing - Jungle
PPeffect_colorC = ppEffectCreate ["ColorCorrections",1500]; 
PPeffect_colorC ppEffectAdjust [1,1,0,[0,1,0.1,0.04],[1,1,1,1],[0.3,0.587,0.114,0]]; 
PPeffect_colorC ppEffectEnable true; 
PPeffect_colorC ppEffectCommit 0;
*/
//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						Sandstorm Effect
//
//------------------------------------------------------------------
//------------------------------------------------------------------

/*
	[object,interval,brightness,newspapers] call BIS_fnc_sandstorm
	position: Object - sandstorm center (should be player)
	interval (Optional): Number - particle refresh time (default is 0.07)
	brightness (Optional): Number - brightness coeficient (default is 1)
	newspapers (Optional): Boolean - true if flying newspapers will be present (default is true)
*/

//[player, 0.9, 0.5, true] call BIS_fnc_sandstorm;


//------------------------------------------------------------------
//------------------------------------------------------------------
//
//					Kisten Dragable mit ACE
//
//------------------------------------------------------------------
//------------------------------------------------------------------

/*
check the weight:	[cursorTarget] call ace_dragging_fnc_getweight;
max weight is:		ACE_maxWeightCarry = 800;
					ACE_maxWeightDrag = 1000;
*/

/*
if isClass (configFile >> "CfgPatches" >> "ace_main") then {
    [crate1, true, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;
    [crate1, true, [0, 2, 0], 90] call ace_dragging_fnc_setDraggable;
};
*/


//------------------------------------------------------------------
//------------------------------------------------------------------
//
//					TFAR Longrange in Fahrzeugen
//
//------------------------------------------------------------------
//------------------------------------------------------------------

// Wird benötigt um West TFAR Longrange Funk in Fahrzeugen anderer Fraktionen zu integrieren

/*
if (isClass(configFile >> "cfgPatches" >> "task_force_radio")) then {
    car1 setVariable ["tf_side", west];
    car1 setVariable ["tf_hasRadio", true];
    car1 setVariable ["TF_RadioType", "tfar_rt1523g"];
};
*/

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						German Rangers GUI
//
//------------------------------------------------------------------
//------------------------------------------------------------------

_playerGrp = group player;

//Bestimmt wann das GR Menü angezeigt wird. Im Umkreis der Basis (Radius 50m)und vor Missionsstart.
_condition = {player distance GR_baseFlag < 100 || missionstarted == false};

// Creating a Sub Menu Category GR Base with Logo
_base_menu = ["GR Base","GR Base","images\GermanRangersLogo.paa",{  },_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions"], _base_menu] call ace_interact_menu_fnc_addActionToClass;

//Add Waffenkammer to ACE Menu GR Base
if (getMissionConfigValue "allowWaffenkammer" == "true") then { 
	_waffenkammer = ["Waffenkammer","Waffenkammer","a3\ui_f\data\gui\rsc\rscdisplayarsenal\spacegarage_ca.paa",{ execVM waffenkammerpfad; },_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","GR Base"], _waffenkammer] call ace_interact_menu_fnc_addActionToClass;
};

// Add Teleport to ACE Menu GR Base
_teleport_action = ["Teleporter","Teleporter","a3\ui_f\data\igui\cfg\simpletasks\types\move_ca.paa",{ [player] spawn GR_fnc_createTeleportDialog; },_condition] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions","GR Base"], _teleport_action] call ace_interact_menu_fnc_addActionToObject;

// Add Loadout to ACE Menu GR Base
if (getMissionConfigValue "allowLoadouts" == "true") then {
	// neue function für Zug 3.0	
	_loadout_action = ["Loadouts","Loadouts","a3\ui_f\data\gui\rsc\rscdisplayarsenal\handgun_ca.paa",{ [player] spawn GR_fnc_createLoadoutDialog; },_condition] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","GR Base"], _loadout_action] call ace_interact_menu_fnc_addActionToObject;	
};

// Debug Funktionen - Nur im Editor / SP verfügbar
if (! isMultiplayer) then {		
	// Full ACE Arsenal Action
	_action = ["open","<t color='#52fc03'>Full ACE Arsenal</t>",["","#52fc03"],{ [player] spawn SGN_fnc_createArsenalACE; },{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject; 	
	
	// Master Packliste Action
	_actionPckList = ["openPackliste","<t color='#fcba03'>Master Packliste</t>",["","#fcba03"],{ [player] spawn SGN_fnc_createPacklisteACE; },{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _actionPckList] call ace_interact_menu_fnc_addActionToObject; 	
	
	// Export Loadout Action
	_export = ["export", "<t color='#eb34d5'>Export LoadOut To Clipboard</t>", ["","#eb34d5"], {[player] spawn SGN_fnc_exportLoadOutArray;}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _export] call ace_interact_menu_fnc_addActionToObject; 
};

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						Zeus Mission Control
//
//------------------------------------------------------------------
//------------------------------------------------------------------

// Creating a Sub Menu Category GR Base with Logo
/*
_mission_control = ["Mission Control","Mission Control","images\GermanRangersLogo.paa",{}, {true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _mission_control] call ace_interact_menu_fnc_addActionToZeus;

_start_mission = ["Missionsstart","Missionsstart","",{ execVM "scripts\core\MCC_chapter_missionstart.sqf"; },{true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions","Mission Control"], _start_mission] call ace_interact_menu_fnc_addActionToZeus;

_mission_succesful = ["Ende: Mission Erfüllt","Ende: Mission Erfüllt","",{ execVM "scripts\core\MCC_chapter_missionendsuccesfull.sqf"; },{true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions","Mission Control"], _mission_succesful] call ace_interact_menu_fnc_addActionToZeus;

_to_be_continued = ["Ende: TO BE CONTINUED","Ende: TO BE CONTINUED","",{ execVM "scripts\core\MCC_chapter_missionendcontinue.sqf"; },{true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions","Mission Control"], _to_be_continued] call ace_interact_menu_fnc_addActionToZeus;
*/

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						Teleport Menü
//
//------------------------------------------------------------------
//------------------------------------------------------------------


// Hauptkategorien

_tp_menu = ["Schnellreise","Schnellreise","a3\ui_f\data\igui\cfg\simpletasks\types\map_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions"], _tp_menu] call ace_interact_menu_fnc_addActionToClass;

_tp_basis = ["Basis","Basis","a3\3den\data\attributes\namesound\special_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise"], _tp_basis] call ace_interact_menu_fnc_addActionToClass;

_tp_pew = ["Waffentraining","Waffentraining","a3\ui_f\data\igui\cfg\weaponicons\srifle_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise"], _tp_pew] call ace_interact_menu_fnc_addActionToClass;

_tp_ca = ["CombinedArms","Combined Arms","a3\ui_f\data\igui\cfg\simpletasks\types\attack_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise"], _tp_ca] call ace_interact_menu_fnc_addActionToClass;

_tp_sonderausb = ["Sonderausbildung","Sonderausbildung","a3\ui_f\data\igui\cfg\simpletasks\types\whiteboard_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise"], _tp_sonderausb] call ace_interact_menu_fnc_addActionToClass;

_tp_aga = ["AGA","AGA","a3\ui_f\data\igui\cfg\simpletasks\types\whiteboard_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise"], _tp_aga] call ace_interact_menu_fnc_addActionToClass;

_tp_aga1 = ["AGA1","AGA 1: Kommunikation","a3\ui_f\data\igui\cfg\simpletasks\types\radio_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA"], _tp_aga1] call ace_interact_menu_fnc_addActionToClass;

_tp_aga2 = ["AGA2","AGA 2: Formationen","a3\3den\data\displays\display3den\entitymenu\movetoformation_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA"], _tp_aga2] call ace_interact_menu_fnc_addActionToClass;

_tp_aga3 = ["AGA3","AGA 3: Orientierung","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA"], _tp_aga3] call ace_interact_menu_fnc_addActionToClass;

_tp_aga4 = ["AGA4","AGA 4: Erste Hilfe","a3\ui_f\data\igui\cfg\simpletasks\types\heal_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA"], _tp_aga4] call ace_interact_menu_fnc_addActionToClass;

_tp_aga5 = ["AGA5","AGA 5: OHK","a3\modules_f\data\editterrainobject\icon32_ca.paa",{},_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA"], _tp_aga5] call ace_interact_menu_fnc_addActionToClass;

// Konkrete Teleportpositionen

_tp_kaserne = ["Kaserne","Kaserne","ca\ui\data\icon_town_ca.paa",{ player setPos getPos tpad_kaserne },_condition] call ace_interact_menu_fnc_createAction;
_tp_sr75 = ["SchießbahnHandfeuerwaffen 75m","Schießbahn: Pistolen 75","a3\3den\data\displays\display3den\entitymenu\arsenal_ca.paa",{ player setPos getPos tpad_75m },_condition] call ace_interact_menu_fnc_createAction;
_tp_150m = ["SchießbahnHandfeuerwaffenAT150mGranaten","Schießbahn: Handfeuerwaffen, AT 150m / Granaten","a3\ui_f\data\igui\cfg\simpletasks\types\rifle_ca.paa",{ player setPos getPos tpad_150m },_condition] call ace_interact_menu_fnc_createAction;
_tp_lr = ["SchießbahnLRATFz","Schießbahn: LR / AT / Fz","a3\data_f_tank\logos\arma3_tank_logo_small_ca.paa",{ player setPos getPos tpad_lr },_condition] call ace_interact_menu_fnc_createAction;
_tp_mines = ["Minenfeld","Minenfeld","a3\ui_f\data\igui\cfg\simpletasks\types\mine_ca.paa",{ player setPos getPos tpad_mines },_condition] call ace_interact_menu_fnc_createAction;
_tp_arty = ["Artillerie","Artillerie","a3\ui_f\data\igui\cfg\simpletasks\types\destroy_ca.paa",{ player setPos getPos tpad_arty },_condition] call ace_interact_menu_fnc_createAction;
_tp_fzg = ["FahrzeugDepot","Fahrzeug-Depot","a3\3den\data\displays\display3den\entitymenu\garage_ca.paa",{ player setPos getPos tpad_fzg },_condition] call ace_interact_menu_fnc_createAction;
_tp_fzpark = ["FahrzeugParkours","Fahrzeug-Parkours","a3\ui_f\data\igui\cfg\commandbar\imagedriver_ca.paa",{ player setPos getPos tpad_fzpark },_condition] call ace_interact_menu_fnc_createAction;
_tp_casa_n = ["CombinedArmsStagingNord","Combined Arms: Staging Nord","a3\ui_f\data\igui\cfg\simpletasks\types\attack_ca.paa",{ player setPos getPos tpad_casa_n },_condition] call ace_interact_menu_fnc_createAction;
_tp_casa_w = ["CombinedArmsStagingWest","Combined West: Staging West","a3\ui_f\data\igui\cfg\simpletasks\types\attack_ca.paa",{ player setPos getPos tpad_casa_w },_condition] call ace_interact_menu_fnc_createAction;
_tp_casa_s = ["CombinedArmsStagingSüd","Combined Arms: Staging Süd","a3\ui_f\data\igui\cfg\simpletasks\types\attack_ca.paa",{ player setPos getPos tpad_casa_s },_condition] call ace_interact_menu_fnc_createAction;
_tp_casa_o = ["CombinedArmsStagingOst","Combined Arms: Staging Ost","a3\ui_f\data\igui\cfg\simpletasks\types\attack_ca.paa",{ player setPos getPos tpad_casa_o },_condition] call ace_interact_menu_fnc_createAction;
_tp_cqb = ["CQBFactory","CQB-Factory","a3\modules_f\data\editterrainobject\icon32_ca.paa",{ player setPos getPos tpad_cqb },_condition] call ace_interact_menu_fnc_createAction;
_tp_see = ["Amphibisch","Amphibisch","a3\ui_f\data\igui\cfg\simpletasks\types\boat_ca.paa",{ player setPos getPos tpad_see },_condition] call ace_interact_menu_fnc_createAction;
_tp_terminal = ["FlugplatzTerminal","Flugplatz: Terminal","a3\ui_f\data\igui\cfg\simpletasks\types\plane_ca.paa",{ player setPos getPos tpad_terminal },_condition] call ace_interact_menu_fnc_createAction;
_tp_hangar = ["FlugplatzHangar","Flugplatz: Hangar","a3\ui_f\data\igui\cfg\simpletasks\types\heli_ca.paa",{ player setPos getPos tpad_hangar },_condition] call ace_interact_menu_fnc_createAction;
_tp_logis = ["Logistikzentrum","Logistikzentrum","a3\ui_f\data\igui\cfg\simpletasks\types\container_ca.paa",{ player setPos getPos tpad_logis },_condition] call ace_interact_menu_fnc_createAction;

_tp_aga1 = ["AGA1","AGA 1","a3\ui_f\data\igui\cfg\simpletasks\types\radio_ca.paa",{ player setPos getPos tpad_AGA1 },_condition] call ace_interact_menu_fnc_createAction;

_tp_aga2 = ["AGA2","AGA 2","a3\3den\data\displays\display3den\entitymenu\movetoformation_ca.paa",{ player setPos getPos tpad_AGA2 },_condition] call ace_interact_menu_fnc_createAction;

_tp_aga3_1 = ["AGA3","AGA 3 Start 1","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_1 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_2 = ["AGA3","AGA 3 Start 2","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_2 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_3 = ["AGA3","AGA 3 Start 3","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_3 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_4 = ["AGA3","AGA 3 Start 4","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_4 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_5 = ["AGA3","AGA 3 Start 5","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_5 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_6 = ["AGA3","AGA 3 Start 6","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_6 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_7 = ["AGA3","AGA 3 Start 7","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_7 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_8 = ["AGA3","AGA 3 Start 8","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_8 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_9 = ["AGA3","AGA 3 Start 9","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_9 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_10 = ["AGA3","AGA 3 Start 10","a3\ui_f\data\igui\cfg\simpletasks\types\navigate_ca.paa",{ player setPos getPos tpad_AGA3_10 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga3_ziel = ["AGA3","AGA 3 Ziel","ca\ui\data\icon_hc_ca.paa",{ player setPos getPos tpad_AGA3_ziel },_condition] call ace_interact_menu_fnc_createAction;

_tp_aga4_1 = ["AGA4","AGA 4 Start 1","a3\ui_f\data\igui\cfg\simpletasks\types\heal_ca.paa",{ player setPos getPos tpad_AGA4_1 },_condition] call ace_interact_menu_fnc_createAction;
_tp_aga4_2 = ["AGA4","AGA 4 Start 2","a3\ui_f\data\igui\cfg\simpletasks\types\heal_ca.paa",{ player setPos getPos tpad_AGA4_2 },_condition] call ace_interact_menu_fnc_createAction;

_tp_aga5 = ["AGA5","AGA 5","a3\modules_f\data\editterrainobject\icon32_ca.paa",{ player setPos getPos tpad_cqb },_condition] call ace_interact_menu_fnc_createAction;

// Zuordnung zu Subkategorien

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Basis"], _tp_kaserne] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Basis"], _tp_terminal] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Basis"], _tp_fzg] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Waffentraining"], _tp_sr75] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Waffentraining"], _tp_150m] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Waffentraining"], _tp_lr] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Waffentraining"], _tp_mines] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Waffentraining"], _tp_arty] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","CombinedArms"], _tp_casa_n] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","CombinedArms"], _tp_casa_w] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","CombinedArms"], _tp_casa_s] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","CombinedArms"], _tp_casa_o] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Sonderausbildung"], _tp_cqb] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Sonderausbildung"], _tp_see] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Sonderausbildung"], _tp_fzpark] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Sonderausbildung"], _tp_hangar] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","Sonderausbildung"], _tp_logis] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA1"], _tp_aga1] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA2"], _tp_aga2] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_1] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_2] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_3] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_4] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_5] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_6] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_7] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_8] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_9] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_10] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA3"], _tp_aga3_ziel] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA4"], _tp_aga4_1] call ace_interact_menu_fnc_addActionToClass;
[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA4"], _tp_aga4_2] call ace_interact_menu_fnc_addActionToClass;

[(typeOf player), 1, ["ACE_SelfActions","Schnellreise","AGA","AGA5"], _tp_aga5] call ace_interact_menu_fnc_addActionToClass;

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						Admin Control Menu
//
//------------------------------------------------------------------
//------------------------------------------------------------------

if (_playerGrp == grplima || _playerGrp == grpkilo || _playerGrp == grpfox || _playerGrp == grpvictor || _playerGrp == grphotel) then {
	// Creating the Admin Control Menu Category GR Base with Logo
	_adminmenu = ["GR Admin Menu","GR Admin Menu","images\GermanRangersLogo.paa",{}, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions"], _adminmenu] call ace_interact_menu_fnc_addActionToClass;

	_avdheal = ["AvD Heal","AvD Heal","a3\ui_f\data\igui\cfg\simpletasks\types\heal_ca.paa",{[player, cursorObject] call ace_medical_treatment_fnc_fullHeal},{true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","GR Admin Menu"], _avdheal] call ace_interact_menu_fnc_addActionToClass;

	//[(typeOf player), 1, ["ACE_SelfActions","GR Admin Menu"], _start_mission] call ace_interact_menu_fnc_addActionToClass;

	//[(typeOf player), 1, ["ACE_SelfActions","GR Admin Menu"], _mission_succesful] call ace_interact_menu_fnc_addActionToClass;
	
	//[(typeOf player), 1, ["ACE_SelfActions","GR Admin Menu"], _to_be_continued] call ace_interact_menu_fnc_addActionToClass;
};

if (_playerGrp == grpmike) then {
	// Creating the Admin Control Menu Category GR Base with Logo
	_avdmenu = ["GR AvD Menu","GR Avd Menu","images\GermanRangersLogo.paa",{}, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions"], _avdmenu] call ace_interact_menu_fnc_addActionToClass;

	_avdheal = ["AvD Heal","AvD Heal","a3\ui_f\data\igui\cfg\simpletasks\types\heal_ca.paa",{[player, cursorObject] call ace_medical_treatment_fnc_fullHeal},{true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","GR AvD Menu"], _avdheal] call ace_interact_menu_fnc_addActionToClass;
};

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						LIMA Supply Point
//
//------------------------------------------------------------------
//------------------------------------------------------------------


//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						LIMA Paletten Supply Point
//
//------------------------------------------------------------------
//------------------------------------------------------------------

if (getMissionConfigValue "limaSupplyPoints" == "true") then {
	if (_playerGrp == grplima || _playerGrp == grpkilo || _playerGrp == grphotel || _playerGrp == grpmike) then {
		
		// Icon für Paletten-deploy
		_icon = "a3\ui_f\data\igui\cfg\cursors\iconboardin_ca.paa";
		_iconPl = "a3\ui_f\data\igui\cfg\simpletasks\types\container_ca.paa";

		// Lima Palett Point Static
		{
			// Parent Action für Luftfracht Paletten  - Leer
			_palettenLF = ["Luftfracht Paletten - Leer","Luftfracht Paletten  - Leer",_iconPl,{ },{true}] call ace_interact_menu_fnc_createAction;
			[_x, 0, ["ACE_MainActions"], _palettenLF] call ace_interact_menu_fnc_addActionToObject;
				//------------------------------------------------------------------
				_plmaster = ["plmaster","Typ 1 - Master",_icon,{[["plmaster",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Leer"], _plmaster] call ace_interact_menu_fnc_addActionToObject;

				_plammosmall = ["plammosmall","Typ 2 - Klein",_icon,{[["plammosmall",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Leer"], _plammosmall] call ace_interact_menu_fnc_addActionToObject;

				_plcasetan = ["plcasetan","Typ 3 - Hardcase",_icon,{[["plcasetan",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Leer"], _plcasetan] call ace_interact_menu_fnc_addActionToObject;

				_plcasemed = ["plcasetan","Typ 4 - Hardcase San",_icon,{[["plcasemed",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Leer"], _plcasemed] call ace_interact_menu_fnc_addActionToObject;
				//------------------------------------------------------------------
			// Parent Action für Luftfracht Paletten  - Logistik
			_palettenLF = ["Luftfracht Paletten - Logistik","Luftfracht Paletten  - Logistik",_iconPl,{ },{true}] call ace_interact_menu_fnc_createAction;
			[_x, 0, ["ACE_MainActions"], _palettenLF] call ace_interact_menu_fnc_addActionToObject;
				//------------------------------------------------------------------
				_plfmun = ["plfmun","Typ 5 - Fahrzeugmunition",_icon,{[["plfmun",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Logistik"], _plfmun] call ace_interact_menu_fnc_addActionToObject;

				_plfuels = ["plfuels","Typ 6 - Treibstoff Klein",_icon,{[["plfuels",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Logistik"], _plfuels] call ace_interact_menu_fnc_addActionToObject;

				_plfuell = ["plfuell","Typ 7 - Treibstoff Gross",_icon,{[["plfuell",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Logistik"], _plfuell] call ace_interact_menu_fnc_addActionToObject;

				_plrepair = ["plcasetan","Typ 8 - Instandsetzung",_icon,{[["plrepair",_this#0], limapfad + "limaPalettPoints.sqf"] remoteExec ["execVM"];},{true}] call ace_interact_menu_fnc_createAction;
				[_x, 0, ["ACE_MainActions", "Luftfracht Paletten - Logistik"], _plrepair] call ace_interact_menu_fnc_addActionToObject;
				//------------------------------------------------------------------
		} forEach [limapalettpointstatic,limaPalettPointStatic_airport];
	};
};

//FoggyBreath
//_units = if (!isMultiplayer) then {switchableUnits} else {playableUnits};
//{[_x, 0.03] execVM "scripts\core\foggy_breath.sqf"} forEach _units;

//Ground Fog
//null = [] execVM "scripts\core\GroundFog.sqf";

//Wenn das Missionsintro gestartet wurde, werden alle Spieler die reconnecten oder später dazu kommen in die Basis teleportiert.
if (getMissionConfigValue "missionstartedfeat" == "true") then {
	if missionstarted then {
		player setPos getPos GR_baseFlag;
	};
};

sleep 1;

titleText ["Missionsvorbereitung", "BLACK IN" ];

//Blurry Back to Visuals
"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [6];
"dynamicBlur" ppEffectCommit 0;
"dynamicBlur" ppEffectAdjust [0.0];
"dynamicBlur" ppEffectCommit 3;

//------------------------------------------------------------------
//------------------------------------------------------------------
//
//						Mod Check
//
// 			Checks Loaded Mods and logs Non Whitelisted
//------------------------------------------------------------------
//------------------------------------------------------------------

[] execVM "scripts\core\modcheck.sqf";