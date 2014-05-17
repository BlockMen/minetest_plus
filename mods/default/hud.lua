default.hud = {}
-- HUD statbar values
default.hud.health = {}
default.hud.hunger = {}
default.hud.armor = {}
default.hud.hunger_out = {}
default.hud.armor_out = {}

-- HUD item ids
local health_hud = {}
local hunger_hud = {}
local armor_hud = {}
local armor_hud_bg = {}

-- default settings
 -- statbar positions
HUD_HEALTH_POS = {x=0.5,y=1}
HUD_HEALTH_OFFSET = {x=-262, y=-87}
HUD_HUNGER_POS = {x=0.5,y=1}
HUD_HUNGER_OFFSET = {x=15, y=-87}
HUD_AIR_POS = {x=0.5,y=1}
HUD_AIR_OFFSET = {x=15,y=-110}
HUD_ARMOR_POS = {x=0.5,y=1}
HUD_ARMOR_OFFSET = {x=-262, y=-110}

HUD_TICK = 0.2
HUD_HUNGER_TICK = 300

HUD_ENABLE_HUNGER = minetest.setting_getbool("hud_hunger_enable")
if HUD_ENABLE_HUNGER == nil then
	HUD_ENABLE_HUNGER = minetest.setting_getbool("enable_damage")
end

HUD_SHOW_ARMOR = minetest.setting_getbool("hud_armor_enable")
if HUD_SHOW_ARMOR == nil then
	HUD_SHOW_ARMOR = minetest.setting_getbool("enable_damage")
end

local function hide_builtin(player)
	 player:hud_set_flags({crosshair = true, hotbar = true, healthbar = false, wielditem = true, breathbar = true})
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
		size = {x=24,y=24},
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
		size = {x=24,y=24},
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
		size = {x=24,y=24},
		text = "default_hud_heart_bg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})
	health_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		size = {x=24,y=24},
		text = "default_hud_heart_fg.png",
		number = player:get_hp(),
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})

 --air
	minetest.hud_replace_builtin("breath", {
		hud_elem_type = "statbar",
		position = HUD_AIR_POS,
		size = {x=24,y=24},
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
		size = {x=24,y=24},
		text = "default_hud_armor_bg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})
	armor_hud[name] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		size = {x=24,y=24},
		text = "default_hud_armor_fg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})
  end
 end
end

-- update hud elemtens if value has changed
local function update_hud(player, item)
	local name = player:get_player_name()

 --health
	local hp = tonumber(default.hud.health[name])
	if item == "health" and player:get_hp() ~= hp then
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
	if item == "armor" and arm_out ~= arm then
		default.armor_update_visual(player)
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
	if item == "hunger" and h_out ~= h then
		default.hud.hunger_out[name] = h
		-- bar should not have more than 10 icons
		if h>20 then h=20 end
		player:hud_change(hunger_hud[name], "number", h)
	end
end



function default.hud.event_handler(player, eventname)
	if not player then return end

	if eventname == "health_changed" then
		update_hud(player, "health")
		if player:get_hp() < 1 then
			default.player_set_animation(player, "lay")
		end
		return true
	end

	if eventname == "breath_changed" then
		return true
	end

	if eventname == "hunger_changed" then
		update_hud(player, "hunger")
		return true
	end

	if eventname == "armor_changed" then
		update_hud(player, "armor")
		return true
	end

	return false
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
	default.hud.event_handler(player, "hunger_changed")

	return true
end

minetest.register_playerevent(default.hud.event_handler)

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
	minetest.after(0.1, function()
		hide_builtin(player)
		custom_hud(player)
		if HUD_ENABLE_HUNGER then default.hud.set_hunger(player) end
		default.armor_update(player)
	end)
end)

minetest.register_on_respawnplayer(function(player)
	default.player_set_animation(player, "stand", 25)
	-- reset player breath since the engine doesnt
	player:set_breath(11)
	-- reset hunger (and save)
	default.hud.hunger[player:get_player_name()] = 20
	if HUD_ENABLE_HUNGER then
		minetest.after(0.5, default.hud.set_hunger, player)
	end
	default.armor_update(player)
end)

