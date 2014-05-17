-- Parameters
local COTCHA = 28

-- constants
local c_grass = minetest.get_content_id("default:dirt_with_grass")
local c_tree = minetest.get_content_id("default:tree")
local c_leaves = minetest.get_content_id("default:leaves")
local c_apple = minetest.get_content_id("default:apple")
local c_air = minetest.get_content_id("air")

local c_trunk = minetest.get_content_id("default:conifer")
local c_needles = minetest.get_content_id("default:needles")


-- 2D noise for snow biomes

local np_snow = {
	offset = 0,
	scale = 1,
	spread = {x=150, y=150, z=150},
	seed = 112,
	octaves = 3,
	persist = 0.5
}

-- Function
local grow_conifer = default.grow_conifer

-- On generated function

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y ~= -32 then
		return
	end

	if minp.y >= SNOW_START-5 then-- or maxp.y >= SNOW_START then
		return
	end

	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local sidelen = x1 - x0 + 1
	local chulens = {x=sidelen, y=sidelen, z=sidelen}
	local minposxz = {x=x0, y=z0}
	
	local nvals_snow = minetest.get_perlin_map(np_snow, chulens):get2dMap_flat(minposxz)
	
	local nixz = 1 -- 2D noise index
	for z = z0, z1 do
	for x = x0, x1 do
		if nvals_snow[nixz] > 1 then -- if snow biomes
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
			if spawny and math.random(COTCHA) == 2 then
				grow_conifer(x, spawny, z, area, data)
			end
		end
		nixz = nixz + 1 -- increment 2D noise index
	end
	end

	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
end)