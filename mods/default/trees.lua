local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_tree = minetest.get_content_id("default:tree")
local c_leaves = minetest.get_content_id("default:leaves")
local c_apple = minetest.get_content_id("default:apple")

function default.grow_tree(data, a, pos, is_apple_tree, seed)
        local pr = PseudoRandom(seed)
        local th = pr:next(4, 5)
        local x, y, z = pos.x, pos.y, pos.z
        for yy = y, y+th-1 do
                local vi = a:index(x, yy, z)
                if a:contains(x, yy, z) and (data[vi] == c_air or yy == y) then
                        data[vi] = c_tree
                end
        end
        y = y+th-1 -- (x, y, z) is now last piece of trunk
        local leaves_a = VoxelArea:new{MinEdge={x=-2, y=-1, z=-2}, MaxEdge={x=2, y=2, z=2}}
        local leaves_buffer = {}
        
        -- Force leaves near the trunk
        local d = 1
        for xi = -d, d do
        for yi = -d, d do
        for zi = -d, d do
                leaves_buffer[leaves_a:index(xi, yi, zi)] = true
        end
        end
        end
        
        -- Add leaves randomly
        for iii = 1, 8 do
                local d = 1
                local xx = pr:next(leaves_a.MinEdge.x, leaves_a.MaxEdge.x - d)
                local yy = pr:next(leaves_a.MinEdge.y, leaves_a.MaxEdge.y - d)
                local zz = pr:next(leaves_a.MinEdge.z, leaves_a.MaxEdge.z - d)
                
                for xi = 0, d do
                for yi = 0, d do
                for zi = 0, d do
                        leaves_buffer[leaves_a:index(xx+xi, yy+yi, zz+zi)] = true
                end
                end
                end
        end
        
        -- Add the leaves
        for xi = leaves_a.MinEdge.x, leaves_a.MaxEdge.x do
        for yi = leaves_a.MinEdge.y, leaves_a.MaxEdge.y do
        for zi = leaves_a.MinEdge.z, leaves_a.MaxEdge.z do
                if a:contains(x+xi, y+yi, z+zi) then
                        local vi = a:index(x+xi, y+yi, z+zi)
                        if data[vi] == c_air or data[vi] == c_ignore then
                                if leaves_buffer[leaves_a:index(xi, yi, zi)] then
                                        if is_apple_tree and pr:next(1, 100) <=  10 then
                                                data[vi] = c_apple
                                        else
                                                data[vi] = c_leaves
                                        end
                                end
                        end
                end
        end
        end
        end
end

-- jungletree
local c_juntree = minetest.get_content_id("default:jungletree")
local c_junleaf = minetest.get_content_id("default:jungleleaves")

function default.grow_jungletree(x, y, z, area, data)
	if y >= SNOW_START then
		return
	end
	--local c_vine = minetest.get_content_id("rainforest:vine")
	local top = math.random(17,23)
	if y+top > SNOW_START then
		top = SNOW_START - y + math.random(-1,5)
	end
	local branch = math.floor(top * 0.6)
	for j = -5, top do
		if j == top or j == top - 1 or j == branch + 1 or j == branch + 2 then
			for i = -2, 2 do -- leaves
			for k = -2, 2 do
				local vi = area:index(x + i, y + j, z + k)
				if math.random(5) ~= 2 then
					data[vi] = c_junleaf
				end
			end
			end
		elseif j <= -1 or j == top - 2 or j == branch then -- branches, roots
			for i = -1, 1 do
			for k = -1, 1 do
				if math.abs(i) + math.abs(k) == 2 then
					local vi = area:index(x + i, y + j, z + k)
					data[vi] = c_juntree
				end
			end
			end
		end
		if j >= 0 and j <= top - 3 then -- climbable nodes
			for i = -1, 1 do
			for k = -1, 1 do
				if math.abs(i) + math.abs(k) == 1 then
					local vi = area:index(x + i, y + j, z + k)
					--data[vi] = c_vine
				end
			end
			end
		end
		if j >= -1 and j <= top - 3 then -- trunk
			local vi = area:index(x, y + j, z)
			data[vi] = c_juntree
		end
	end
end

-- conifer
local c_trunk = minetest.get_content_id("default:conifer")
local c_needles = minetest.get_content_id("default:needles")

function default.grow_conifer(x, y, z, area, data)
	local top = math.random(12,16)
	local branch = math.floor(top * 0.5)
	local aaa = 1
	for j = 0, top do
		if j > branch and j <= top and aaa < 1 then --leaves
			aaa = 1
			local w = top-j-1
			if w > 3 then w = 3 end
			for i = -w, w do
			for k = -w, w do
				local vi = area:index(x + i, y + j, z + k)
				--if math.random(5) ~= 2 then
					data[vi] = c_needles
				--end
			end
			end
		elseif aaa > 0 then
			aaa = 0
		end
		if j >= -1 and j <= top - 3 then -- trunk
			local vi = area:index(x, y + j, z)
			data[vi] = c_trunk
		end
	end
	local vi = area:index(x, y+top-2, z)
	data[vi] = c_needles
end
