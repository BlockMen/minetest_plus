-- Reduce particles send to client if on Server
local SERVER = minetest.is_singleplayer() or false
SERVER = not SERVER
local dur = 0
if SERVER then
	dur = 5
end

local TORCH_VIEW_DISTANCE = 13 -- if player is near that distance flames are shown
local dirs = {{-1,0,-1},{-1,0,0},{0,0,-1},
{1,0,1},{1,0,0},{0,0,1},{0,1,0}}

function check_attached_node_fdir(p, n)
	local def = minetest.registered_nodes[n.name]
	local d = {x=0, y=0, z=0}
	if def.paramtype2 == "facedir" then
		if n.param2 == 0 then
			d.z = 1
		elseif n.param2 == 1 then
			d.x = 1
		elseif n.param2 == 2 then
			d.z = -1
		elseif n.param2 == 3 then
			d.x = -1
		end
	end
	local p2 = {x=p.x+d.x, y=p.y+d.y, z=p.z+d.z}
	local nn = minetest.env:get_node(p2).name
	local def2 = minetest.registered_nodes[nn]
	if def2 and not def2.walkable then
		return false
	end
	return true
end

local function is_wall(wallparam)
	if wallparam == 0 then return false end
	local para2 = 0
	if wallparam == 2 then
		para2 = 1
	elseif wallparam == 3 then
		para2 = 3
	elseif wallparam == 4 then
		para2 = 0
	elseif wallparam == 5 then
		para2 = 2
	end
	return para2
end

local function player_near(pos)
	for  _,object in ipairs(minetest.get_objects_inside_radius(pos, TORCH_VIEW_DISTANCE)) do
		if object:is_player() then
			return true
		end
	end

	return false
end

-- abms for flames
minetest.register_abm({
	nodenames = {"default:torch_wand", "default:torch_floor"},
	interval = 1+dur,
	chance = 1,
	action = function(pos)
		if player_near(pos) then
			default.add_fire(pos, 1, dur)
		end
	end
})

--node_boxes
minetest.register_craftitem(":default:torch", {
	description = "Torch",
	inventory_image = "default_torch_inv.png",
	wield_image = "default_torch.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = false,
   	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" or string.find(minetest.get_node(pointed_thing.above).name, "torch") then
			return itemstack
		end
		local above = pointed_thing.above
		local under = pointed_thing.under
		local wdir = minetest.dir_to_wallmounted({x = under.x - above.x, y = under.y - above.y, z = under.z - above.z})
		local u_n = minetest.get_node(under)
		local udef = minetest.registered_nodes[u_n.name]
		if u_n and udef and not udef.walkable then above = under end
		u_n = minetest.get_node(above)
		udef = minetest.registered_nodes[u_n.name]
		if u_n and udef and udef.walkable then return itemstack end
		if wdir == 1 then
			minetest.add_node(above, {name = "default:torch_floor"})		
		else
			minetest.add_node(above, {name = "default:torch_wand", param2 = is_wall(wdir)})
		end
		if not wdir == 0 or not minetest.setting_getbool("creative_mode") then
			itemstack:take_item()
		end
		default.add_fire(above, 1, dur)
		return itemstack
	end
})

minetest.register_node("default:torch_floor", {
	--description = "Fakel",
	inventory_image = "default_torch_inv.png",
	wield_image = "default_torch.png",
	wield_scale = {x=1,y=1,z=1+2/16},
	drawtype = "nodebox",
	tiles = {"default_torch.png^[transformfy", "default_wood.png", "default_torch.png",
		"default_torch.png^[transformfx", "default_torch.png", "default_torch.png"},
	paramtype = "light",
	paramtype2 = "none",
	sunlight_propagates = true,
	drop = "default:torch",
	walkable = false,
	light_source = 13,
	groups = {choppy=2,dig_immediate=3,flammable=1,not_in_creative_inventory=1,torch=1},
	legacy_wallmounted = true,
	node_box = {
		type = "fixed",
		fixed = {-1/16, -0.5, -1/16, 1/16, 2/16, 1/16},
	},
	selection_box = {
		type = "fixed",
		fixed = {-1/16, -0.5, -1/16, 1/16, 2/16, 1/16},
	},
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if not digger:is_player() then minetest.add_item(pos, {name="default:torch"}) end
	end,
	update = function(pos,node, pos2)
		if pos2.y < pos.y then
			minetest.dig_node(pos)
		end
	end,
})

local wall_ndbx = {
			{-1/16,-6/16, 6/16, 1/16, -5/16, 0.5},
			{-1/16,-5/16, 5/16, 1/16, -4/16, 7/16},
			{-1/16,-4/16, 4/16, 1/16, -3/16, 6/16},
			{-1/16,-3/16, 3/16, 1/16, -2/16, 5/16},
			{-1/16,-2/16, 2/16, 1/16, -1/16, 4/16},
			{-1/16,-1/16, 1/16, 1/16, 0, 3/16},
			{-1/16,0, 1/16, 1/16, 1/16, 2/16},
			{-1/16, 0, -1/16, 1/16, 2/16, 1/16},
}

minetest.register_node("default:torch_wand", {
	--description = "Fakel",
	inventory_image = "default_torch_inv.png",
	wield_image = "default_torch.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	drawtype = "nodebox",
	tiles = {"default_torch.png^[transformfy", "default_wood.png", "default_torch_side.png",
		"default_torch_side.png^[transformfx", "default_wood.png", "default_torch.png"},

	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	light_source = 13,
	groups = {choppy=2,dig_immediate=3,flammable=1,not_in_creative_inventory=1,torch=1},
	legacy_wallmounted = true,
	drop = "default:torch",
	node_box = {
		type = "fixed",
		fixed =	wall_ndbx
	},
	selection_box = {
		type = "fixed",
		fixed =	{-1/16, -6/16, 7/16, 1/16, 2/16, 2/16},
	},
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if not digger:is_player() then minetest.add_item(pos, {name="default:torch"}) end
	end,
	update = function(pos,node)
		if not check_attached_node_fdir(pos, node) then
			minetest.dig_node(pos)
		end
	end,

})

minetest.register_alias("default:wand",  "default:torch_wand")
minetest.register_alias("default:floor",  "default:torch_floor")

minetest.register_on_dignode(function(pos, oldnode, digger)
	if minetest.find_node_near(pos, 1, {"group:torch"}) == nil then return end
	for i=1,#dirs do
		local v = dirs[i]
		local p = {x=pos.x+v[1],y=pos.y+v[2],z=pos.z+v[3]}
		local n = minetest.get_node_or_nil(p)
		if n and n.name then
			local def = minetest.registered_nodes[n.name]
			if def and def.update then
				def.update(p, n, pos)
			end
		end
	end
end)
