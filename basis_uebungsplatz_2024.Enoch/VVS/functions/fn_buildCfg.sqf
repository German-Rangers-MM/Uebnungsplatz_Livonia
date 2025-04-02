/*
	File: fn_buildCfg.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Builds our configuration arrays for vehicles to display.
	
	0: classname
	1: scope
	2: picture
	3: displayname
	4: vehicleclass
	5: side
	6: faction

	edited by [TF]def 2015 09 20 (0.4.1)
*/
_Cfg = configFile >> "CfgVehicles";

//Setup our final arrays.
VVS_pre_Car = [];
VVS_pre_Air = [];
VVS_pre_Ship = [];
VVS_pre_Armored = [];
VVS_pre_Autonomous = [];
VVS_pre_Support = [];

//Skim over and make sure VVS_x isn't built for a pre-made vehicle list.
if(count VVS_Car > 0) then {VVS_pre_Car = VVS_Car;};
// def 2015 09 19>
if(count VVS_Air > 0) then {VVS_pre_Air = VVS_Air;};
if(count VVS_Ship > 0) then {VVS_pre_Ship = VVS_Ship;};
// def 2015 09 20>
// <def 2015 09 20
if(count VVS_Armored > 0) then {VVS_pre_Armored = VVS_Armored;};
// <def 2015 09 19
if(count VVS_Autonomous > 0) then {VVS_pre_Autonomous = VVS_Autonomous;};
if(count VVS_Support > 0) then {VVS_pre_Support = VVS_Support;};

if(VVS_Premade_List) exitWith {}; //No need to waste CPU processing time as the mission designer already setup a list.

for "_i" from 0 to (count _Cfg)-1 do
{
	_class = _Cfg select _i;
	if(isClass _class) then
	{
		_className = configName _class;
		if(_className != "") then
		{
		//	systemChat _className;
			_cfgInfo = [_className] call VVS_fnc_cfgInfo;
			//systemChat str(_cfgInfo);
			if(count _cfgInfo > 0) then
			{
				_scope = _cfgInfo select 1;
				_picture = _cfgInfo select 2;
				_displayName = _cfgInfo select 3;
				_vehicleClass = _cfgInfo select 4;
				_side = _cfgInfo select 5;	
				_superClass = _cfgInfo select 7;    

// 1) ADD YOUR OWN VEHICLE CLASS AT THE END OF CLASSES ARRAY ON THE NEXT STRING:
				if(_scope >= 2 && _picture != "" && _displayName != "" && _vehicleClass in ["Car","Ship","Air","Armored","Submarine","Autonomous","Support","GerRng_FENNEK_NEF_W","GerRng_B_FENNEK_GER_Wdl","GerRng_B_FENNEK_GER_HMG_Wdl","GerRng_B_FENNEK_GER_GMG_Wdl","GerRng_Van_Transport_BW","GerRng_IVECO_Medic_W","GerRng_IVECO_Transport_W","GerRng_B_Dingo_GER_Wdl","I_E_Van_02_medevac_F","B_T_LSV_01_armed_F","B_T_LSV_01_AT_F","B_T_LSV_01_unarmed_F","B_Quadbike_01_F","B_GEN_Offroad_01_covered_F","GerRng_IVECO_Transport_Covered_W","GerRng_AW101_Merlin_TTH_01","GerRng_CH_47F_TTH_01","GerRng_CH_47F_TTH_VIV_01","GerRng_Ch_146_Griffon_MedEvac_01","GerRng_CH_146_Griffon_CAS_01","CUP_B_MK10_GB","CUP_B_LCU1600_USMC","B_SDV_01_F","B_Boat_Transport_01_F","B_Boat_Armed_01_minigun_F","CUP_B_RHIB_HIL","I_C_Boat_Transport_02_F","CUP_B_Leopard2A6_GER","B_T_APC_Tracked_01_CRV_F","B_T_APC_Wheeled_01_cannon_F","CUP_B_Boxer_HMG_GER_WDL","I_LT_01_cannon_F","I_LT_01_AT_F","I_LT_01_scout_F","I_LT_01_AA_F","B_UAV_01_F","B_T_UGV_01_olive_F","B_T_UGV_01_rcws_olive_F","B_UGV_02_Demining_F","B_Slingload_01_Cargo_F","B_Slingload_01_Fuel_F","B_Slingload_01_Medevac_F","B_Slingload_01_Repair_F","CUP_B_M1129_MC_MK19_Woodland","GerRng_Lkw15t_Ammo_W","GerRng_Lkw15t_Flatbed_W","GerRng_IVECO_Repair_W","GerRng_IVECO_Ammo_W","GerRng_IVECO_Fuel_W","GerRng_Lkw15t_Repair_W"] // << ADD YOUR VEHICLE CLASS AT THE END OF THE CLASSES ARRAY ","YOUR CLASS"]

				) then
				{
// def 2015 09 20>
// 2) THEN ADD YOUR OWN VEHICLE CLASS AT THE END OF PREFFERED SUBCLASSE ARRAY ON ONE OF THE NEXT STRINGS:
// FOR EXAMPLE, YOU WANT TO ADD CLASS "AIR2" TO AIR VEHICLE SPAWNER. ADD IT ON LINE 83 RIGHT AFTER "rhs_vehclass_helicopter".

		// CARS and trucks
					if ((count VVS_Car > 0) && (_vehicleClass in ["Car","GerRng_FENNEK_NEF_W","GerRng_B_FENNEK_GER_Wdl","GerRng_B_FENNEK_GER_HMG_Wdl","GerRng_B_FENNEK_GER_GMG_Wdl","GerRng_Van_Transport_BW","GerRng_IVECO_Medic_W","GerRng_IVECO_Transport_W","GerRng_B_Dingo_GER_Wdl","I_E_Van_02_medevac_F","B_T_LSV_01_armed_F","B_T_LSV_01_AT_F","B_T_LSV_01_unarmed_F","B_Quadbike_01_F","B_GEN_Offroad_01_covered_F","GerRng_IVECO_Transport_Covered_W"])) then
					{ VVS_pre_Car set[count VVS_pre_Car,_className]; };
		// SHIPS and Submarines
					if ((count VVS_Ship > 0) && (_vehicleClass in ["Ship","Submarine","CUP_B_MK10_GB","CUP_B_LCU1600_USMC","B_SDV_01_F","B_Boat_Transport_01_F","B_Boat_Armed_01_minigun_F","CUP_B_RHIB_HIL","I_C_Boat_Transport_02_F"])) then
					{ VVS_pre_Ship set[count VVS_pre_Ship,_className]; };
		// AIR
					if ((count VVS_Air > 0) && (_vehicleClass in ["Air","GerRng_AW101_Merlin_TTH_01","GerRng_CH_47F_TTH_01","GerRng_CH_47F_TTH_VIV_01","GerRng_Ch_146_Griffon_MedEvac_01","GerRng_CH_146_Griffon_CAS_01"])) then
					{ VVS_pre_Air set[count VVS_pre_Air,_className]; };
		// ARMORED (TANKS, APC, IFV, ARTILLERY)
					if ((count VVS_Armored > 0) && (_vehicleClass in ["Armored","CUP_B_Leopard2A6_GER","B_T_APC_Tracked_01_CRV_F","B_T_APC_Wheeled_01_cannon_F","CUP_B_Boxer_HMG_GER_WDL","I_LT_01_cannon_F","I_LT_01_AT_F","I_LT_01_scout_F","I_LT_01_AA_F"])) then
					{ VVS_pre_Armored set[count VVS_pre_Armored,_className]; };
		// Autonomous and rhs AA
					if ((count VVS_Autonomous > 0) && (_vehicleClass in ["Autonomous","B_UAV_01_F","B_T_UGV_01_olive_F","B_T_UGV_01_rcws_olive_F","B_UGV_02_Demining_F"])) then
					{ VVS_pre_Autonomous set[count VVS_pre_Autonomous,_className]; };
		// Support, rhs radar, rhs launcher, rhs targeting
					if ((count VVS_Support > 0) && (_vehicleClass in ["Support","B_Slingload_01_Cargo_F","B_Slingload_01_Fuel_F","B_Slingload_01_Medevac_F","B_Slingload_01_Repair_F","CUP_B_M1129_MC_MK19_Woodland","GerRng_Lkw15t_Ammo_W","GerRng_Lkw15t_Flatbed_W","GerRng_IVECO_Repair_W","GerRng_IVECO_Ammo_W","GerRng_IVECO_Fuel_W","GerRng_Lkw15t_Repair_W"])) then
					{ VVS_pre_Support set[count VVS_pre_Support,_className]; };
// <def 2015 09 20
				};
			};
		};
	};
};