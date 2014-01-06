--
-- Papyrus and Cactus
--
minetest.register_node("default:cactus", {
	description = "Cactus",
	tiles = {"default_cactus_top.png", "default_cactus_top.png", "default_cactus_side.png"},
	is_ground_content = true,
	groups = {snappy=1,choppy=3,flammable=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	damage_per_second = 1,
	node_box = {
		type = "fixed",
		fixed = {{-7/16, -0.5, -7/16, 7/16, 0.5, 7/16}, {-8/16, -0.5, -7/16, -7/16, 0.5, -7/16},
			 {7/16, -0.5, -7/16, 7/16, 0.5, -8/16},{-7/16, -0.5, 7/16, -7/16, 0.5, 8/16},{7/16, -0.5, 7/16, 8/16, 0.5, 7/16}}--
	},
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -0.5, -7/16, 7/16, 0.5, 7/16},
				
	},
	on_punch = function(pos, node, puncher)
		if not puncher then return end

		if puncher:get_wielded_item():get_name() == "" then 
			minetest.sound_play("player_damage", {pos = pos, gain = 0.3, max_hear_distance = 10}) 
		end
	end,
})

minetest.register_node("default:papyrus", {
	description = "Papyrus",
	drawtype = "plantlike",
	tiles = {"default_papyrus.png"},
	inventory_image = "default_papyrus.png",
	wield_image = "default_papyrus.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {snappy=3,flammable=2},
	sounds = default.node_sound_leaves_defaults(),
})

--
-- Grass
--
minetest.register_node("default:grass_1", {
	description = "Grass",
	drawtype = "plantlike",
	tiles = {"default_grass_1.png"},
	-- use a bigger inventory image
	inventory_image = "default_grass_3.png",
	wield_image = "default_grass_3.png",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	drop = {
		max_items = 1,
		items = {
			{items = {'default:seed_wheat'},rarity = 5},
		}
	},
	groups = {snappy=3,flammable=3,flora=1,attached_node=1,dig_immediate=3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("default:grass_"..math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("default:grass_1 "..itemstack:get_count()-(1-ret:get_count()))
	end,
})

local wav = 0
for i=2,5 do
	if i>2 then wav=1 end
	minetest.register_node("default:grass_"..i, {
		description = "Grass",
		drawtype = "plantlike",
		tiles = {"default_grass_"..i..".png"},
		inventory_image = "default_grass_"..i..".png",
		wield_image = "default_grass_"..i..".png",
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		waving = wav,
		is_ground_content = true,
		drop = {
			max_items = 1,
			items = {
				{items = {'default:seed_wheat'},rarity = 5},
			}
		},
		groups = {snappy=3,flammable=3,flora=1,attached_node=1,not_in_creative_inventory=1,dig_immediate=3},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.4, -0.5, -0.4, 0.4, -0.5+(2.5*i)/16, 0.4},
		},
	})
end

--
-- Junglegrass
--

minetest.register_node("default:junglegrass", {
	description = "Jungle Grass",
	drawtype = "plantlike",
	visual_scale = 1.3,
	tiles = {"default_junglegrass.png"},
	inventory_image = "default_junglegrass.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	waving = 1,
	is_ground_content = true,
	drop = {
		max_items = 1,
		items = {
			{items = {'default:seed_cotton'},rarity = 8},
		}
	},
	groups = {snappy=3,flammable=2,flora=1,attached_node=1,dig_immediate=3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})


minetest.register_node("default:dry_shrub", {
	description = "Dry Shrub",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_dry_shrub.png"},
	inventory_image = "default_dry_shrub.png",
	wield_image = "default_dry_shrub.png",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	drop = "",
	groups = {snappy=3,flammable=3,attached_node=1,dig_immediate=3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})

--
-- Wheat
--
wav = 0
for i=1,8 do
	if i>5 then wav=1 end
	local drop = {
		items = {
			{items = {'default:wheat'},rarity=9-i},
			{items = {'default:wheat'},rarity=18-i*2},
			{items = {'default:seed_wheat'},rarity=9-i},
			{items = {'default:seed_wheat'},rarity=18-i*2},
		}
	}
	minetest.register_node("default:wheat_"..i, {
		drawtype = "nodebox",
		tiles = {"default_wheat_"..i..".png"},
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		is_ground_content = true,
		waving = wav,
		drop = drop,
		node_box = {
		type = "fixed",
		fixed = {{-0.5, -0.5, 0.25, 0.5, -0.5+13/16, 0.25}, {-0.5, -0.5, -0.25, 0.5, -0.5+13/16, -0.25}, 
			{0.25, -0.5, -0.5, 0.25, -0.5+13/16, 0.5}, {-0.25, -0.5, -0.5, -0.25, -0.5+13/16, 0.5}} --2 pro richtung
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.4, -0.5, -0.4, 0.4, -0.5+(2*i)/16, 0.4},
		},
		groups = {snappy=3,flammable=2,plant=1,wheat=i,not_in_creative_inventory=1,attached_node=1},
		sounds = default.node_sound_leaves_defaults(),
	})
end

minetest.register_node("default:wild_wheat", {
		--drawtype = "nodebox",
		drawtype = "plantlike",
		tiles = {"default_wheat_7.png"},
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		is_ground_content = true,
		waving = 1,
		drop = {
			items = {
				{items = {'default:wheat'},rarity=2},
				{items = {'default:seed_wheat'},rarity=9},
				{items = {'default:seed_wheat'}},
				}
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
		},
		groups = {snappy=3,flammable=2,plant=1,wheat=8,not_in_creative_inventory=1,attached_node=1},
		sounds = default.node_sound_leaves_defaults(),
	})

--
-- Cotton
--

for i=1,8 do
	local drop = {
		items = {
			{items = {'default:string'},rarity=9-i},
			{items = {'default:string'},rarity=18-i*2},
			{items = {'default:string'},rarity=27-i*3},
			{items = {'default:seed_cotton'},rarity=9-i},
			{items = {'default:seed_cotton'},rarity=18-i*2},
			{items = {'default:seed_cotton'},rarity=27-i*3},
		}
	}
	minetest.register_node("default:cotton_"..i, {
		drawtype = "plantlike",
		tiles = {"default_cotton_"..i..".png"},
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		is_ground_content = true,
		drop = drop,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {snappy=3,flammable=2,plant=1,cotton=i,not_in_creative_inventory=1,attached_node=1},
		sounds = default.node_sound_leaves_defaults(),
	})
end