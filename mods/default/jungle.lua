-- rainforest 0.1.2 by paramat
-- For latest stable Minetest and back to 0.4.8
-- Depends default
-- License: code WTFPL
-- slightly changed for MT+

-- Parameters

local JUTCHA = 16
local JUGCHA = 2

-- 2D noise for snow biomes

local np_snow = {
	offset = 0,
	scale = 1,
	spread = {x=150, y=150, z=150},
	seed = 112,
	octaves = 3,
	persist = 0.5
}

-- Stuff

rainforest = {}

-- Nodes

--[[minetest.register_node("rainforest:vine", {
	description = "RF Jungletree Vine",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	groups = {not_in_creative_inventory=1},
})]]

-- Function
local grow_jungletree = default.grow_jungletree

-- On generated function
local snow_value = SNOW_START/2+3

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y ~= -32 then
		return
	end

	if minp.y >= snow_value then-- or maxp.y >= SNOW_START then
		return
	end

	--local t1 = os.clock()
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z
	
	--print ("[rainforest] chunk minp ("..x0.." "..y0.." "..z0..")")
	
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local c_grass = minetest.get_content_id("default:dirt_with_grass")
	local c_jgrass = {}
	c_jgrass[1] = minetest.get_content_id("default:junglegrass")
	c_jgrass[2] = minetest.get_content_id("default:junglegrass_small")
	local c_tree = minetest.get_content_id("default:tree")
	local c_leaves = minetest.get_content_id("default:leaves")
	local c_apple = minetest.get_content_id("default:apple")
	local c_air = minetest.get_content_id("air")
	
	local sidelen = x1 - x0 + 1
	local chulens = {x=sidelen, y=sidelen, z=sidelen}
	local minposxz = {x=x0, y=z0}
	
	local nvals_snow = minetest.get_perlin_map(np_snow, chulens):get2dMap_flat(minposxz)
	
	local nixz = 1 -- 2D noise index
	for z = z0, z1 do
	for x = x0, x1 do
		local n_val = nvals_snow[nixz]
		if n_val < -0.6 and n_val > -0.8 then -- if away from snow biomes
			local spawny = false
			for y = y1, 1, -1 do -- find surface and erase appletrees
				local vi = area:index(x, y, z)
				local c_node = data[vi]
				if c_node == c_grass then -- if surface is dirt_with_grass
					spawny = y + 1
					break
				elseif c_node == c_tree -- if appletree
				or c_node == c_leaves
				or c_node == c_apple then
					data[vi] = c_air -- erase
				end
			end
			if spawny and spawny < snow_value and math.random(JUTCHA) == 2 then
				grow_jungletree(x, spawny, z, area, data)
			elseif spawny  and spawny < snow_value and math.random(JUGCHA) == 2 then
				local visp = area:index(x, spawny, z)
				data[visp] = c_jgrass[math.random(1,2)]
			end
		end
		nixz = nixz + 1 -- increment 2D noise index
	end
	end
	
	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
	--local chugent = math.ceil((os.clock() - t1) * 1000)
	--print ("[rainforest] "..chugent.." ms")
end)