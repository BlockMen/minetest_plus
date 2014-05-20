-- Minetest 0.4 mod: player
-- See README.txt for licensing and other information.

--[[

API
---

default.player_register_model(name, def)
^ Register a new model to be used by players.
^ <name> is the model filename such as "character.x", "foo.b3d", etc.
^ See Model Definition below for format of <def>.

default.registered_player_models[name]
^ See Model Definition below for format.

default.player_set_model(player, model_name)
^ <player> is a PlayerRef.
^ <model_name> is a model registered with player_register_model.

default.player_set_animation(player, anim_name [, speed])
^ <player> is a PlayerRef.
^ <anim_name> is the name of the animation.
^ <speed> is in frames per second. If nil, default from the model is used

default.player_set_textures(player, textures)
^ <player> is a PlayerRef.
^ <textures> is an array of textures
^ If <textures> is nil, the default textures from the model def are used

default.player_get_animation(player)
^ <player> is a PlayerRef.
^ Returns a table containing fields "model", "textures" and "animation".
^ Any of the fields of the returned table may be nil.

Model Definition
----------------

model_def = {
	animation_speed = 30, -- Default animation speed, in FPS.
	textures = {"character.png", }, -- Default array of textures.
	visual_size = {x=1, y=1,}, -- Used to scale the model.
	animations = {
		-- <anim_name> = { x=<start_frame>, y=<end_frame>, },
		foo = { x= 0, y=19, },
		bar = { x=20, y=39, },
		-- ...
	},
}

]]

default.player = {}

-- Player animation blending
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
local animation_blend = 0

default.registered_player_models = {}

-- Local for speed.
local models = default.registered_player_models

function default.player_register_model(name, def)
	models[name] = def
end

-- Default player appearance
default.player_register_model("character.x", {
	animation_speed = 25,
	textures = {"character.png"},
	animations = {
		-- Standard animations.
		stand     = { x=  0, y= 79, },
		lay       = { x=162, y=166, },
		walk      = { x=168, y=187, },
		mine      = { x=189, y=198, },
		walk_mine = { x=200, y=219, },
		-- Extra animations (not currently used by the game).
		sit       = { x= 81, y=160, },
	},
})

-- Player stats and animations
local player_model = {}
local player_textures = {}
local player_anim = {}
local player_sneak = {}
local player_sprint = {}
local player_wielded = {}

default.player_exhaustion = {}
local player_exhaustion = default.player_exhaustion

function default.player_get_animation(player)
	local name = player:get_player_name()
	return {
		model = player_model[name],
		textures = player_textures[name],
		animation = player_anim[name],
	}
end

-- Called when a player's appearance needs to be updated
function default.player_set_model(player, model_name)
	local name = player:get_player_name()
	local model = models[model_name]
	if model then
		if player_model[name] == model_name then
			return
		end
		player:set_properties({
			mesh = model_name,
			textures = player_textures[name] or model.textures,
			visual = "mesh",
			visual_size = model.visual_size or {x=1, y=1},
		})
		default.player_set_animation(player, "stand")
	else
		player:set_properties({
			textures = { "player.png", "player_back.png", },
			visual = "upright_sprite",
		})
	end
	player_model[name] = model_name
end

local function get_wielded(player, txtures)
	local name = player:get_player_name()
	local item = player:get_wielded_item()
	local item_name = item:get_name()
	local update = false
	if player_wielded[name] ~= item_name then
		update = true
		player_wielded[name] = item_name
	else
		return txtures, false
	end

	local i_txt = "default_trans.png"
	local b_txt = "default_trans.png"

	if item and item_name then
		local def = minetest.registered_items[item_name]
		if def then
			if def.drawtype and def.drawtype == "normal" or def.drawtype == "allfaces_optional" then-- and not def.drawtype == "torchlike" then
				b_txt = def.tiles[1]
			else
				if def.drawtype then
					i_txt = def.inventory_image.."^[transformR90"
				else
					i_txt = def.inventory_image
				end
			end	
		end
		if item_name == "" then
			i_txt = "default_trans.png"
		end
	end
	if not txtures then
		txtures = player_textures[name]
	end
	txtures[3] = i_txt
	txtures[4] = b_txt
	return txtures, update
end

function default.player_set_textures(player, textures)
	local name = player:get_player_name()
	if not textures then
		textures = player_textures[name]
	else
		player_wielded[name] = ""
	end
	local new_textures = get_wielded(player, textures)
	player_textures[name] = new_textures
	player:set_properties({textures = new_textures})
end

function default.player_set_animation(player, anim_name, speed)
	local name = player:get_player_name()
	if player_anim[name] == anim_name then
		return
	end
	local model = player_model[name] and models[player_model[name]]
	if not (model and model.animations[anim_name]) then
		return
	end
	local anim = model.animations[anim_name]
	player_anim[name] = anim_name
	player:set_animation(anim, speed or model.animation_speed, animation_blend)
end

function default.player_set_sprint(player, state)
	local name = player:get_player_name()
	if player_sprint[name] == state then
		return
	else
		player_sprint[name] = state
		if state == true then
			player:set_physics_override(1.8, 1, 1)
		else
			player:set_physics_override(1, 1, 1)
		end
	end	
end

function default.set_player_inventory(player)
	local player_name = player:get_player_name()
        player:set_inventory_formspec(
		"size[8,8.5]"..
		"bgcolor[#000A;true]"..
		"background[-0.19,-0.25;8.41,9.25;default_formspec_bg.png^default_formspec_player.png]"..
		"list[current_player;main;0,4.25;8,1;]"..
                "list[current_player;main;0,5.5;8,3;8]"..
		"list[current_player;craft;0.5,0.5;3,3;]"..
		"list[current_player;craftpreview;4.5,1.5;1,1;]"..
		--armor
		"list[detached:"..player_name.."_armor;armor_head;7,0;1,1;]"..
		"list[detached:"..player_name.."_armor;armor_torso;7,1;1,1;]"..
		"list[detached:"..player_name.."_armor;armor_legs;7,2;1,1;]"..
		"list[detached:"..player_name.."_armor;armor_feet;7,3;1,1;]"..
		"listcolors[#AAA0;#FFF5]"
        )
end

-- Update appearance and formspec when the player joins
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	default.player[name] = {}--player
	default.player_set_model(player, "character.x")
	player:set_local_animation({x=0, y=79}, {x=168, y=187}, {x=189, y=198}, {x=200, y=219}, 22)--18 for sneaking perfect
	if minetest.setting_getbool("creative_mode") then
		creative.set_creative_formspec(player, 0, 1)
	else
		default.set_player_inventory(player)
	end
	-- sometimes the model get not applied correct, so do it again
	minetest.after(0, default.player_set_model, player, "character.x")
	player_exhaustion[name] = 0
end)

-- Localize for better performance.
local player_set_animation = default.player_set_animation
local player_set_sprint = default.player_set_sprint

-- Check each player and apply animations
minetest.register_globalstep(function(dtime)
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local model_name = player_model[name]
		local model = model_name and models[model_name]
		if model then
			local txt, update = get_wielded(player)
			if update then
				default.player_set_textures(player)
			end
			local controls = player:get_player_control()
			local walking = false
			local animation_speed_mod = model.animation_speed or 30

			-- Determine if the player is walking
			if controls.up or controls.down or controls.left or controls.right then
				walking = true
				player_exhaustion[name] = player_exhaustion[name] + 0.002
			end

			-- Determine if the player is sneaking, and reduce animation speed if so
			if controls.sneak then
				animation_speed_mod = animation_speed_mod / 2
			end

			-- Apply animations based on what the player is doing
			if walking then
				if player_sneak[name] ~= controls.sneak then
					player_anim[name] = nil
					player_sneak[name] = controls.sneak
				end
				if controls.LMB then
					player_set_animation(player, "walk_mine", animation_speed_mod)
				else
					player_set_animation(player, "walk", animation_speed_mod)
				end
			elseif controls.LMB then
				player_set_animation(player, "mine")
			elseif default.hud.health[name] > 0 then
				player_set_animation(player, "stand", animation_speed_mod)
			end

			-- sprint
			if controls.up and controls.left and controls.right then
				player_set_sprint(player, true)
				player_exhaustion[name] = player_exhaustion[name] + 0.11
			else
				player_set_sprint(player, false)
			end
		end
	end
end)

--
-- the hand
--

local tool_cap = {
	full_punch_interval = 1.0,
	max_drop_level = 0,
	groupcaps = {
		fleshy = {times={[2]=2.00, [3]=1.00}, uses=0, maxlevel=1},
		crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
		snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
		oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3},
	}
}

if minetest.setting_getbool("creative_mode") then
	tool_cap = {
		full_punch_interval = 0.5,
		max_drop_level = 3,
		groupcaps = {
			crumbly = {times={[1]=0.3, [2]=0.3, [3]=0.3}, uses=0, maxlevel=3},
			cracky = {times={[1]=0.3, [2]=0.3, [3]=0.3}, uses=0, maxlevel=3},
			snappy = {times={[1]=0.3, [2]=0.3, [3]=0.3}, uses=0, maxlevel=3},
			choppy = {times={[1]=0.3, [2]=0.3, [3]=0.3}, uses=0, maxlevel=3},
			oddly_breakable_by_hand = {times={[1]=0.3, [2]=0.3, [3]=0.3}, uses=0, maxlevel=3},
		},
		damage_groups = {fleshy = 10},
	}
end

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=0.9,y=1,z=3.2},
	tool_capabilities = tool_cap,
})
