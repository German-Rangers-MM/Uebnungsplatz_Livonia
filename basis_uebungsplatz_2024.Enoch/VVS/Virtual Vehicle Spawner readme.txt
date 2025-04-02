VVS - Virtual Vehicle Spawner
Author: Bryan "Tonic" Boardwine
===============================

Installation pt1: VVS Folder
=============================
Move the VVS Folder into your scenario folder which will be located here:
C:\Users\username\Documents\Arma 3\missions

Installation pt2: Description.ext
==================================
Put the following code into a description.ext

#include "VVS\menu.h"

class CfgFunctions
{
	#include "VVS\Functions.h"
};


Addaction Codes
===============
Add the following addaction codes to an object that 
you will be using to access the VVS menu:
=========================================
All vehicles
============
 this addAction ["All",VVS_fnc_openVVS,["VVS_all_1","All"]];

Cars
====
 this addAction ["Cars", VVS_fnc_openVVS, ["VVS_car_1", "Car"]];

Armored
=======
 this addAction ["Armored",VVS_fnc_openVVS,["VVS_tank_1","Armored"]];

Air
===
 this addAction ["Helicopters & Planes",VVS_fnc_openVVS,["VVS_air_1","Air"]];

Boats
=====
 this addAction ["Boats",VVS_fnc_openVVS,["VVS_ship_1","Ship"]];

Support
=======
 this addAction ["Support",VVS_fnc_openVVS,["VVS_Support_1","Support"]];

Autonomous
==========
 this addAction ["Autonomous",VVS_fnc_openVVS,["VVS_Autonomous_1","Autonomous"]];

===========
Map Markers
===========
These are the markers you will be putting on the map that
will create the spawn point for a vehicle to spawn.
The 3rd word in the addaction arrays above is the marker name.

Credits
- Readme by Gunter Severloh

_reset = ["SpawnCars", "<t color='#ffff00'>Spawn: Autos, LKWs und MRAPS</t>",["","#ffff00"],["VVS_Logis1", "Car"] call VVS_fnc_openVVS,{true}] call ace_interact_menu_fnc_createAction; 
 
[this, 0, ["ACE_MainActions"], _reset] call ace_interact_menu_fnc_addActionToObject;