default.player.armor = {}

local elements = {"head", "torso", "legs", "feet"}

default.armor_update_visual = function(player)
	local name = player:get_player_name()
	--local list = dump(default.player[name].armor)
	local textures = ""
	for _,v in ipairs(elements) do
		local element = default.player[name].armor["armor_"..v]
		if element ~= nil then
			textures = textures .. "^"..element:gsub("%:", "_")..".png"
		end
	end
	if textures == "" then textures = "default_armor_trans.png" end
	default.player_set_textures(player, {"character.png",
			textures:sub(1),
			"default_trans.png",--to show no wielded items
			"default_trans.png",
		})
end

-- called by hud when hp changed
default.armor_update = function(player, heal, list, old_hp)
	if not player then
		return
	end
	local name = player:get_player_name()

	local player_inv = player:get_inventory()
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})
	if not armor_inv then
		return
	end
	local now_hp = player:get_hp()
	local heal_max = 0
	local state = 0
	local items = 0
	for _,v in ipairs(elements) do
		local stack = armor_inv:get_stack("armor_"..v, 1)
		if stack:get_count() > 0 then
			if heal and old_hp~=nil and now_hp < old_hp then
				local use = stack:get_definition().groups["armor_use"] or 0
				local heal_p = stack:get_definition().groups["armor_heal"] or 0
				local item = stack:get_name()
				local damage_amount = (old_hp-now_hp)/2
				use = use * damage_amount
				stack:add_wear(use)
				armor_inv:set_stack("armor_"..v, 1, stack)
				player_inv:set_stack("armor_"..v, 1, stack)
				heal_max = heal_max + heal_p
			end
			if list then
				default.player[name].armor["armor_"..v] = stack:get_name()
			end
			if stack:get_wear() < 1 and stack:get_count() == 0 then
				default.player[name].armor["armor_"..v] = nil
			else
				state = state + stack:get_wear()
				items = items + 1
			end
		end
	end
	default.player[name].armor["wear"] = state
	default.player[name].armor["cnt"] = items
	local max = 4*65535
	local lvl = max - state
	lvl = lvl/max
	if state == 0 and items == 0 then
		lvl = 0
	end
	if default.hud ~= nil then
		default.hud.armor[name] = lvl*(items*5)
	end
	default.armor_update_visual(player)
	if heal and heal_max > math.random(100) and player:get_hp() > 0 then
		--player:set_hp(old_hp)
		return true
	end
	--default.armor_update_visual(player)
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	default.player[name].armor = {}
	default.player[name].armor["cnt"] = 0
	default.player[name].armor["wear"] = 0

	default.player_set_textures(player, {"character.png",
			"default_trans.png",
			"default_trans.png",--to show no wielded items
			"default_trans.png",
		})

	local player_inv = player:get_inventory()
	local armor_inv = minetest.create_detached_inventory(name.."_armor",{
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			default.player[name].armor[listname] = stack:get_name()
			default.player[name].armor["cnt"] = default.player[name].armor["cnt"] + 1
			default.armor_update(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
			default.player[name].armor[listname] = nil
			default.player[name].armor["cnt"] = default.player[name].armor["cnt"] - 1
			default.armor_update(player)--armor:set_player_armor(player)
		end,
		allow_put = function(inv, listname, index, stack, player)
			local field = minetest.registered_items[stack:get_name()]
			if (field and field.groups[listname] and field.groups[listname] ~= 0) and inv:is_empty(listname) then
				return 1
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
	})

	for _,v in ipairs(elements) do
		local list = "armor_"..v
		player_inv:set_size(list, 1)
		armor_inv:set_size(list, 1)
		armor_inv:set_stack(list, 1, player_inv:get_stack(list, 1))
	end

	default.armor_update(player, false, true)
end)
