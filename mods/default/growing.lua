--
-- Grow grass
--

minetest.register_abm({
        nodenames = {"default:dirt"},
        interval = 2,
        chance = 200,
        action = function(pos, node)
                local above = {x=pos.x, y=pos.y+1, z=pos.z}
                local name = minetest.get_node(above).name
                local nodedef = minetest.registered_nodes[name]
                if nodedef and (nodedef.sunlight_propagates or nodedef.paramtype == "light")
                                and nodedef.liquidtype == "none"
                                and ((minetest.get_node_light(above) or 0) >= 13) then
                        if name == "default:snow" or name == "default:snowblock" then
                                minetest.set_node(pos, {name = "default:dirt_with_snow"})
                        else
                                minetest.set_node(pos, {name = "default:dirt_with_grass"})
                        end
                end
        end
})

--
-- Grow trees
--

minetest.register_abm({
        nodenames = {"default:sapling"},
        interval = 10,
        chance = 50,
        action = function(pos, node)
                local is_soil = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name].groups.soil
                if is_soil == nil or is_soil == 0 then return end
                print("A sapling grows into a tree at "..minetest.pos_to_string(pos))
                local vm = minetest.get_voxel_manip()
                local minp, maxp = vm:read_from_map({x=pos.x-16, y=pos.y, z=pos.z-16}, {x=pos.x+16, y=pos.y+16, z=pos.z+16})
                local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
                local data = vm:get_data()
                default.grow_tree(data, a, pos, math.random(1, 4) == 1, math.random(1,100000))
                vm:set_data(data)
                vm:write_to_map(data)
                vm:update_map()
        end
})

minetest.register_abm({
        nodenames = {"default:junglesapling"},
        interval = 10,
        chance = 50,
        action = function(pos, node)
		local is_soil = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name].groups.soil
		if is_soil == nil or is_soil == 0 then return end
		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-16, y=pos.y-1, z=pos.z-16}, {x=pos.x+16, y=pos.y+24, z=pos.z+16})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		default.grow_jungletree(pos.x, pos.y, pos.z, a, data)--pos, math.random(1,100000))(x, y, z, area, data)--(data, a, pos, seed)
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
        end
})

minetest.register_abm({
        nodenames = {"default:conifer_sapling"},
        interval = 10,
        chance = 50,
        action = function(pos, node)
		local is_soil = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name].groups.soil
		if is_soil == nil or is_soil == 0 then return end
		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-16, y=pos.y-1, z=pos.z-16}, {x=pos.x+16, y=pos.y+17, z=pos.z+16})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		default.grow_conifer(pos.x, pos.y, pos.z, a, data)
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
        end
})

--
-- Papyrus and cactus growing
--

minetest.register_abm({
	nodenames = {"default:cactus"},
	neighbors = {"group:sand"},
	interval = 50,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if minetest.get_item_group(name, "sand") ~= 0 then
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "default:cactus" and height < 4 do
				height = height+1
				pos.y = pos.y+1
			end
			if height < 4 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:cactus"})
				end
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"default:papyrus"},
	neighbors = {"default:dirt", "default:dirt_with_grass"},
	interval = 50,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if name == "default:dirt" or name == "default:dirt_with_grass" then
			if minetest.find_node_near(pos, 3, {"group:water"}) == nil then
				return
			end
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "default:papyrus" and height < 4 do
				height = height+1
				pos.y = pos.y+1
			end
			if height < 4 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:papyrus"})
				end
			end
		end
	end,
})

--
-- Wheat
--

minetest.register_abm({
	nodenames = {"group:wheat"},
	neighbors = {"group:soil"},
	interval = 90,
	chance = 2,
	action = function(pos, node)
		-- return if already full grown
		if minetest.get_item_group(node.name, "wheat") == 8 then
			return
		end
		
		-- check if on wet soil
		pos.y = pos.y-1
		local n = minetest.get_node(pos)
		if minetest.get_item_group(n.name, "soil") < 3 then
			return
		end
		pos.y = pos.y+1
		
		-- check light
		if not minetest.get_node_light(pos) then
			return
		end
		if minetest.get_node_light(pos) < 13 then
			return
		end
		
		-- grow
		local height = minetest.get_item_group(node.name, "wheat") + 1
		minetest.set_node(pos, {name="default:wheat_"..height})
	end
})

--
-- Cotton
--

minetest.register_abm({
	nodenames = {"group:cotton"},
	neighbors = {"group:soil"},
	interval = 80,
	chance = 2,
	action = function(pos, node)
		-- return if already full grown
		if minetest.get_item_group(node.name, "cotton") == 8 then
			return
		end
		
		-- check if on wet soil
		pos.y = pos.y-1
		local n = minetest.get_node(pos)
		if minetest.get_item_group(n.name, "soil") < 3 then
			return
		end
		pos.y = pos.y+1
		
		-- check light
		if not minetest.get_node_light(pos) then
			return
		end
		if minetest.get_node_light(pos) < 13 then
			return
		end
		
		-- grow
		local height = minetest.get_item_group(node.name, "cotton") + 1
		minetest.set_node(pos, {name="default:cotton_"..height})
	end
})