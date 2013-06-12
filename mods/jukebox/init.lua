minetest.register_node("jukebox:box", {
	description = "Jukebox",
	drawtype = "nodebox",
	tiles = {"jukebox_top.png", "default_wood.png", "jukebox_side.png",
		"jukebox_side.png", "jukebox_front.png", "jukebox_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	stack_max = 1,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
				
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("main") then
			if clicker:get_wielded_item():get_name() == "jukebox:disc" then
				inv:set_stack("main",1, itemstack:take_item())
				meta:set_string("hwnd",minetest.sound_play("jukebox_song", {gain = 0.5, max_hear_distance = 25}))
			end
		else
			local drop_pos = minetest.env:find_node_near(pos, 1, "air")
			if drop_pos == nil then drop_pos = {x=pos.x, y=pos.y+1,z=pos.z} end
			minetest.env:add_item(drop_pos, inv:get_stack("main",1))
			if meta:get_string("hwnd") then minetest.sound_stop(meta:get_string("hwnd")) end
			inv:remove_item("main",inv:get_stack("main",1))
		end

	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 1)
	end,	
	on_destruct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("main") then
			local drop_pos = minetest.env:find_node_near(pos, 1, "air")
			if drop_pos == nil then drop_pos = {x=pos.x, y=pos.y+1,z=pos.z} end
			minetest.env:add_item(drop_pos, inv:get_stack("main",1))
			if meta:get_string("hwnd") then minetest.sound_stop(meta:get_string("hwnd")) end
		end
	end,
})


minetest.register_craftitem("jukebox:disc", {
	description = "Music Disc",
	inventory_image = "jukebox_disc.png",
	liquids_pointable = false,
	stack_max = 1

})

minetest.register_craft({
	output = "jukebox:box",
	recipe = {
		{"group:wood", "group:wood", "group:wood", },
		{"group:wood", "default:diamond", "group:wood", },
		{"group:wood", "group:wood", "group:wood", }
	}
})

minetest.register_craft({
	output = "jukebox:disc",
	recipe = {
		{"", "default:coal_lump", "", },
		{"default:coal_lump", "default:gold_lump", "default:coal_lump", },
		{"", "default:coal_lump", "", }
	}
})