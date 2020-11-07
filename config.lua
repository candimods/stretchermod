local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 217, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config              = {}
Config.OpenMenuSpawn= {x = 266.62, y = -1354.23, z = 24.53}

Config.Hash = {
	{hash = `20f450ambo`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `e450ambo`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `16ramambo`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `safdm2`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `ambulance`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `safdm3`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `safr2`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `emsgator`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `coronervan`, detection = 2.4, depth = -1.0, height = 0.0},
}

Config.ItemsVeh = {
  -- {hash = `name of vehicle`, item = 'es_extend item name', remove = how many item to remove on use},
  {hash = `Stretcher`,          type = 'veh',  item = 'stretcher',  remove = 1}, -- When using the stretcher  item, it will spawn a Stretcher vehicle and remove 1x item
  {hash = `stryker_M1`,         type = 'veh',  item = 'stretcher2', remove = 1},
  {hash = `stryker_M1_coroner`, type = 'veh',  item = 'stretcher3', remove = 1},
  {hash = `prop_ld_binbag_01`,  type = 'prop', item = 'stretcher4', remove = 1}, -- When using the stretcher  item, it will spawn a prop_ld_binbag_01 prop and remove 1x item
  {hash = `mxpro`,              type = 'veh',  item = 'stretcher5', remove = 1},
  {hash = `stretcher_basket`,	type = 'veh',  item = 'stretcher6', remove = 1},
}

Config.Press = {
	open_menu = Keys["Y"],
	take_bed = Keys["E"],
	do_action = Keys["E"],
	out_vehicle_bed = Keys["E"],
	release_bed = Keys["B"],
	in_vehicle_bed = Keys["E"],
	go_out_bed = Keys["E"],
	open_close_doors = Keys["E"],
	extend_powerload = Keys["Z"],
	take_stow_stretcher = Keys["G"],
	extra_1 = Keys["CAPS"],
	lights = Keys["ENTER"],
}


Config.Language = {
	name_hospital = 'Stretcher',
	open_menu = 'Press ~b~E',
	do_action = 'Press ~INPUT_CONTEXT~ to interact with stretcher',
	take_bed = "Press ~INPUT_CONTEXT~ to take stretcher",
	release_bed = "Press ~INPUT_SPECIAL_ABILITY_SECONDARY~ to drop stretcher",
	in_vehicle_bed = "Press ~INPUT_CONTEXT~ to stow stretcher",
	out_vehicle_bed = "Press ~INPUT_CONTEXT~ to retrieve stretcher",
	go_out_bed = "Get Out of Bed",
	delete_bed = "Remove Bed",
	fold_bed = "Fold Bed",
	toggle_iv = "Toggle IV Pole",
	toggle_lp15 = "Toggle Lifepak15 Defib",
	toggle_lucas = "Toggle Lucas 3",
	toggle_backboard = "Toggle Backboard",
	toggle_scoop = "Toggle scoop",
	toggle_seat = "Toggle Headrest",
	lit_1 = "Bed without matela",
	anim = {
		spawn_command = "Litter",
		lie_back = "Lie on back",
		sit_up = "Sit up",
		sit_right = "Sit on the right side",
		sit_left = "Sit on left side",
		convulse = "Recieve CPR",
		death = "Lay Still",
		pls = "Lay sideways",
	}
}

Config.lit_1 = {		--- coods every anim coords - z up and down - r is rotation - body
    {anim = "savecouch@",lib = "t_sleep_loop_couch",name = Config.Language.anim.lie_back, x = 0, y = 0.1, z = 1.2, r = 180.0},
    {anim = "anim@gangops@morgue@table@",lib = "body_search",name = Config.Language.anim.death, x = 0, y = 0.1, z = 1.52, r = 180.0},
    {anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name =Config.Language.anim.sit_right, x = 0.0, y = -0.2, z =0.55, r = -90.0},
    {anim = "amb@prop_human_seat_chair_food@male@base",lib = "base",name = Config.Language.anim.sit_left, x = 0.0, y = -0.2, z =0.55, r = 90.0},
    {anim = "timetable@jimmy@mics3_ig_15@",lib = "mics3_15_base_jimmy",name = Config.Language.anim.sit_up, x = 0.0, y = 0.15, z =1.52, r = 180.0},
    {anim = "missheistfbi3b_ig8_2",lib = "cpr_loop_victim",name = Config.Language.anim.convulse, x = 0.0, y = 0.1, z = 1.52, r = 175.0},
    {anim = "amb@world_human_bum_slumped@male@laying_on_right_side@base",lib = "base",name = Config.Language.anim.pls, x = 0.2, y = 0.1, z = 1.6, r = 100.0},
}

Config.Lits = {
	{lit = `stretcher`,          distance_stop = 2.4, anims = Config.lit_1, title = Config.Language.lit_1},
	{lit = `stryker_M1`,         distance_stop = 2.4, anims = Config.lit_1, title = Config.Language.lit_1},
	{lit = `stryker_M1_coroner`, distance_stop = 2.4, anims = Config.lit_1, title = Config.Language.lit_1},
	{lit = `mxpro`,              distance_stop = 2.4, anims = Config.lit_1, title = Config.Language.lit_1},
	{lit = `stretcher_basket`,   distance_stop = 2.4, anims = Config.lit_1, title = Config.Language.lit_1},
}
