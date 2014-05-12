default.hud = {}
-- HUD statbar values
default.hud.health = {}
default.hud.hunger = {}
default.hud.air = {}
default.hud.armor = {}
default.hud.hunger_out = {}
default.hud.armor_out = {}

-- HUD item ids
local health_hud = {}
local hunger_hud = {}
local air_hud = {}
local armor_hud = {}
local armor_hud_bg = {}

-- default settings
 -- statbar positions
HUD_HEALTH_POS = {x=0.5,y=0.9}
HUD_HEALTH_OFFSET = {x=-175, y=2}
HUD_HUNGER_POS = {x=0.5,y=0.9}
HUD_HUNGER_OFFSET = {x=15, y=2}
HUD_AIR_POS = {x=0.5,y=0.9}
HUD_AIR_OFFSET = {x=15,y=-15}
HUD_ARMOR_POS = {x=0.5,y=0.9}
HUD_ARMOR_OFFSET = {x=-175, y=-15}

HUD_TICK = 0.2
HUD_HUNGER_TICK = 300

HUD_ENABLE_HUNGER = minetest.setting_getbool("hud_hunger_enable")
if HUD_ENABLE_HUNGER == nil then
	HUD_ENABLE_HUNGER = minetest.setting_getbool("enable_damage")
end

HUD_SHOW_ARMOR = false
if minetest.get_modpath("3d_armor") ~= nil then
	HUD_SHOW_ARMOR = true
end

local function hide_builtin(player)
	 player:hud_set_flags({crosshair = true, hotbar = true, healthbar = false, wielditem = true, breathbar = false})
end

local function custom_hud(player)
 local name = player:get_player_name()

-- fancy hotbar (only when no crafting mod present)
 if minetest.get_modpath("crafting") == nil then
	player:hud_set_hotbar_image("default_hud_hotbar.png")
	player:hud_set_hotbar_selected_image("default_hud_hotbar_selected.png")
 end

 if minetest.setting_getbool("enable_damage") then
 --hunger
	if HUD_ENABLE_HUNGER then
       	 player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HUNGER_POS,
		size = {x=16, y=16},
		text = "default_hud_hunger_bg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_HUNGER_OFFSET,
	 })
	local h = default.hud.hunger[name]
	if h == nil or h > 20 then h = 20 end
	 hunger_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HUNGER_POS,
		size = {x=16, y=16},
		text = "default_hud_hunger_fg.png",
		number = h,
		alignment = {x=-1,y=-1},
		offset = HUD_HUNGER_OFFSET,
	 })
	end
 --health
        player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		size = {x=16, y=16},
		text = "default_hud_heart_bg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})
	health_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		size = {x=16, y=16},
		text = "default_hud_heart_fg.png",
		number = player:get_hp(),
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})

 --air
	air_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_AIR_POS,
		scale = {x=1, y=1},
		text = "default_hud_air_fg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_AIR_OFFSET,
	})

 --armor
 if HUD_SHOW_ARMOR then
       armor_hud_bg[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		scale = {x=1, y=1},
		text = "default_hud_armor_bg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})
	armor_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		scale = {x=1, y=1},
		text = "default_hud_armor_fg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})
  end
 end
end

--needs to be defined for older version of 3darmor
function default.hud.set_armor()
end


--if HUD_ENABLE_HUNGER then dofile(minetest.get_modpath("hud").."/hunger.lua") end
if HUD_SHOW_ARMOR then dofile(minetest.get_modpath("hud").."/armor.lua") end

-- update hud elemtens if value has changed
local function update_hud(player)
	local name = player:get_player_name()
 --air
	local air = tonumber(default.hud.air[name])
	if player:get_breath() ~= air then
		air = player:get_breath()
		default.hud.air[name] = air
		if air > 10 then air = 0 end
		player:hud_change(air_hud[name], "number", air*2)
	end
 --health
	local hp = tonumber(default.hud.health[name])
	if player:get_hp() ~= hp then
		if default.armor_update(player, true, false, hp) and hp > 0 then
			player:set_hp(hp)
		else
			hp = player:get_hp()
			default.hud.health[name] = hp
			player:hud_change(health_hud[name], "number", hp)
		end
	end
 --armor
	local arm_out = tonumber(default.hud.armor_out[name])
	if not arm_out then arm_out = 0 end
	local arm = tonumber(default.hud.armor[name])
	if not arm then arm = 0 end
	if arm_out ~= arm then
		default.hud.armor_out[name] = arm
		player:hud_change(armor_hud[name], "number", arm)
		if (default.player[name].armor["cnt"] == 0) and arm == 0 then
		 player:hud_change(armor_hud_bg[name], "number", 0)
		else
		 player:hud_change(armor_hud_bg[name], "number", 20)
		end
	end
 --hunger
	local h_out = tonumber(default.hud.hunger_out[name])
	local h = tonumber(default.hud.hunger[name])
	if h_out ~= h then
		default.hud.hunger_out[name] = h
		-- bar should not have more than 10 icons
		if h>20 then h=20 end
		player:hud_change(hunger_hud[name], "number", h)
	end
end

default.hud.get_hunger = function(player)
	local inv = player:get_inventory()
	if not inv then return nil end
	local hgp = inv:get_stack("hunger", 1):get_count()
	if hgp == 0 then
		hgp = 21
		inv:set_stack("hunger", 1, ItemStack({name=":", count=hgp}))
	else
		hgp = hgp
	end
	return hgp-1
end

default.hud.set_hunger = function(player)
	local inv = player:get_inventory()
	local name = player:get_player_name()
	local value = default.hud.hunger[name]
	if not inv  or not value then return nil end
	if value > 30 then value = 30 end
	if value < 0 then value = 0 end
	
	inv:set_stack("hunger", 1, ItemStack({name=":", count=value+1}))

	return true
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local inv = player:get_inventory()
	inv:set_size("hunger",1)
	default.hud.health[name] = player:get_hp()
	if HUD_ENABLE_HUNGER then
		default.hud.hunger[name] = default.hud.get_hunger(player)
		default.hud.hunger_out[name] = default.hud.hunger[name]
	end
	default.hud.armor[name] = 0
	default.hud.armor_out[name] = 0
	local air = player:get_breath()
	default.hud.air[name] = air
	minetest.after(0.5, function()
		hide_builtin(player)
		custom_hud(player)
		if HUD_ENABLE_HUNGER then default.hud.set_hunger(player) end
		default.armor_update(player)
	end)
end)

minetest.register_on_respawnplayer(function(player)
	-- reset player breath since the engine doesnt
	player:set_breath(11)
	-- reset hunger (and save)
	default.hud.hunger[player:get_player_name()] = 20
	if HUD_ENABLE_HUNGER then
		minetest.after(0.5, default.hud.set_hunger, player)
	end
	default.armor_update(player)
end)

local main_timer = 0
local timer = 0
local timer2 = 0
minetest.after(2.5, function()
	minetest.register_globalstep(function(dtime)
	 main_timer = main_timer + dtime
	 timer = timer + dtime
	 timer2 = timer2 + dtime
		if main_timer > HUD_TICK or timer > 4 or timer2 > HUD_HUNGER_TICK then
		 if main_timer > HUD_TICK then main_timer = 0 end
		 for _,player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()

			-- only proceed if damage is enabled
			if minetest.setting_getbool("enable_damage") then
			 local h = tonumber(default.hud.hunger[name])
			 local hp = player:get_hp()
			 if HUD_ENABLE_HUNGER and timer > 4 then
				-- heal player by 1 hp if not dead and saturation is > 15 (of 30)
				if h > 15 and hp > 0 and default.hud.air[name] > 0 then
					player:set_hp(hp+1)
				-- or damage player by 1 hp if saturation is < 2 (of 30)
				elseif h <= 1 and minetest.setting_getbool("enable_damage") then
					if hp-1 >= 0 then player:set_hp(hp-1) end
				end
			 end
			 -- lower saturation by 1 point after xx seconds
			 if HUD_ENABLE_HUNGER and timer2 > HUD_HUNGER_TICK then
				if h > 0 then
					h = h-1
					default.hud.hunger[name] = h
					default.hud.set_hunger(player)
				end
			 end
			 -- update current armor level
			 if HUD_SHOW_ARMOR then default.hud.get_armor(player) end

			 -- update all hud elements
			 update_hud(player)
			end
		 end
		
		end
		if timer > 4 then timer = 0 end
		if timer2 > HUD_HUNGER_TICK then timer2 = 0 end
	end)
end)

--[[
local function costum_hud(player)
 local name = player:get_player_name()

--fancy hotbar
 if minetest.get_modpath("crafting") == nil then
	player:hud_set_hotbar_image("default_hud_hotbar.png")
	player:hud_set_hotbar_selected_image("default_hud_hotbar_selected.png")
 end

 if minetest.setting_getbool("enable_damage") then
 --hunger
	if HUD_ENABLE_HUNGER then
       	 player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HUNGER_POS,
		scale = {x=1, y=1},
		text = "default_hud_hunger_bg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_HUNGER_OFFSET,
	 })

	 hunger_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HUNGER_POS,
		scale = {x=1, y=1},
		text = "default_hud_hunger_fg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_HUNGER_OFFSET,
	 })
	end
 --health
        player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		scale = {x=1, y=1},
		text = "default_hud_heart_bg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})

	health_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		scale = {x=1, y=1},
		text = "default_hud_heart_fg.png",
		number = player:get_hp(),
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})

 --air
	air_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_AIR_POS,
		scale = {x=1, y=1},
		text = "default_hud_air_fg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_AIR_OFFSET,
	})

 --armor
 if HUD_SHOW_ARMOR then
       armor_hud_bg[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		scale = {x=1, y=1},
		text = "default_hud_armor_bg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})

	armor_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		scale = {x=1, y=1},
		text = "default_hud_armor_fg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})
  end
 end
end

local function update_hud(player)
	local name = player:get_player_name()
 --air
	local air = tonumber(default.hud.air[name])
	if player:get_breath() ~= air then
		air = player:get_breath()
		default.hud.air[name] = air
		if air > 10 then air = 0 end
		player:hud_change(air_hud[name], "number", air*2)
	end
 --health
	local hp = tonumber(default.hud.health[name])
	if player:get_hp() ~= hp then
		if default.armor_update(player, true, false, hp) and hp > 0 then
			player:set_hp(hp)
		else
			hp = player:get_hp()
			default.hud.health[name] = hp
			player:hud_change(health_hud[name], "number", hp)
		end
	end
 --armor
	local arm_out = tonumber(default.hud.armor_out[name])
	if not arm_out then arm_out = 0 end
	local arm = tonumber(default.hud.armor[name])
	if not arm then arm = 0 end
	if arm_out ~= arm then
		default.hud.armor_out[name] = arm
		player:hud_change(armor_hud[name], "number", arm)
		if (default.player[name].armor["cnt"] == 0) and arm == 0 then
		 player:hud_change(armor_hud_bg[name], "number", 0)
		else
		 player:hud_change(armor_hud_bg[name], "number", 20)
		end
	end
 --hunger
	local h_out = tonumber(default.hud.hunger_out[name])
	local h = tonumber(default.hud.hunger[name])
	if h_out ~= h then
		default.hud.hunger_out[name] = h
		-- bar should not have more than 10 icons
		if h>20 then h=20 end
		player:hud_change(hunger_hud[name], "number", h)
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	default.hud.health[name] = player:get_hp()
	local air = player:get_breath()
	default.hud.air[name] = air
	--if HUD_ENABLE_HUNGER then default.hud.hunger[name] = default.hud.load_hunger(player) end
	if not default.hud.hunger[name] then
		default.hud.hunger[name] = 20
	end
	default.hud.hunger_out[name] = default.hud.hunger[name]
	default.hud.armor[name] = 0
	default.hud.armor_out[name] = 0
	minetest.after(0.5, function()
		hide_builtin(player)
		costum_hud(player)
		--if HUD_ENABLE_HUNGER then default.hud.save_hunger(player) end
		default.armor_update(player)
	end)
end)


minetest.register_on_respawnplayer(function(player)
	default.hud.hunger[player:get_player_name()] = 20
	minetest.after(0.5, function()
		--if HUD_ENABLE_HUNGER then default.hud.save_hunger(player) end
	end)
end)

local timer = 0
local timer2 = 0
minetest.after(2.5, function()
	minetest.register_globalstep(function(dtime)
	 timer = timer + dtime
	 timer2 = timer2 + dtime
		for _,player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()

			-- only proceed if damage is enabled
			if minetest.setting_getbool("enable_damage") then
			 local h = tonumber(default.hud.hunger[name])
			 local hp = player:get_hp()
			 if HUD_ENABLE_HUNGER and timer > 4 then
				-- heal player by 1 hp if not dead and saturation is > 15 (of 30)
				if h > 15 and hp > 0 then
					player:set_hp(hp+1)
				-- or damage player by 1 hp if saturation is < 2 (of 30) and player would not die
				elseif h <= 1 and minetest.setting_getbool("enable_damage") then
					if hp-1 >= 1 then player:set_hp(hp-1) end
				end
			 end
			 -- lower saturation by 1 point after xx seconds
			 if HUD_ENABLE_HUNGER and timer2 > HUD_HUNGER_TICK then
				if h > 1 then
					h = h-1
					default.hud.hunger[name] = h
					--default.hud.save_hunger(player)
				end
			 end
			 -- update current armor level
			 --if HUD_SHOW_ARMOR then default.hud.get_armor(player) end

			 -- update all hud elements
			 update_hud(player)
			end
		end
		
		if timer > 4 then timer = 0 end
		if timer2 > HUD_HUNGER_TICK then timer2 = 0 end
	end)
end)]]