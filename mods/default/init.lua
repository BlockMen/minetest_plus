-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

WATER_ALPHA = 200
WATER_VISC = 1
LAVA_VISC = 7
LIGHT_MAX = 14
SNOW_START = 27

-- Definitions made by this mod that other mods can use too
default = {}

local load_more = true

-- Check engine version and load files
if dump(minetest.hud_replace_builtin) == "nil" then
	load_more = false
	minetest.after(3,function()
		minetest.chat_send_all("#WARNING: Your version of Minetest is outdated and can't run Minetest+ properly")
	end)
end

dofile(minetest.get_modpath("default").."/functions.lua")
dofile(minetest.get_modpath("default").."/sounds.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/plants.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")

if load_more then
	dofile(minetest.get_modpath("default").."/tools.lua")
	dofile(minetest.get_modpath("default").."/food.lua")
	dofile(minetest.get_modpath("default").."/growing.lua")
	dofile(minetest.get_modpath("default").."/intweak.lua")
	dofile(minetest.get_modpath("default").."/craftitems.lua")
	dofile(minetest.get_modpath("default").."/crafting.lua")
	dofile(minetest.get_modpath("default").."/trees.lua")
	dofile(minetest.get_modpath("default").."/jungle.lua")
	dofile(minetest.get_modpath("default").."/conifers.lua")
	dofile(minetest.get_modpath("default").."/player.lua")
	dofile(minetest.get_modpath("default").."/armor.lua")
	dofile(minetest.get_modpath("default").."/hud.lua")
	dofile(minetest.get_modpath("default").."/hunger.lua")
	dofile(minetest.get_modpath("default").."/torches.lua")
end
