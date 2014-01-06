--
-- Sound tables
--

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=1.0}
	table.dug = table.dug or
			{name="default_dug_node", gain=1.0}
	table.place = table.place or
			{name="default_place_node", gain=0.5}
	return table
end

function default.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_hard_footstep", gain=0.2}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=0.5}
	--table.dug = table.dug or
	--		{name="default_dirt_break", gain=0.5}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_grass_footstep", gain=0.25}
	--table.dug = table.dug or
	--		{name="default_dirt_break", gain=0.25}
	table.dug = table.dug or
			{name="default_grass_footstep.2", gain=0.25}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_hard_footstep", gain=0.3}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_grass_footstep", gain=0.25}
	table.dig = table.dig or
			{name="default_dig_crumbly", gain=0.4}
	table.dug = table.dug or
			{name="", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_hard_footstep", gain=0.25}
	table.dug = table.dug or
			{name="default_break_glass", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_snow_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_snow_footstep", gain=0.3}
	table.dug = table.dug or
			{name="default_snow_footstep", gain=0.55}
	default.node_sound_defaults(table)
	return table
end

--
-- Lava particles and Lava sound
--

minetest.register_abm({
	nodenames = {"default:lava_source"},
	interval = 2,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.sound_play("default_lava", {pos = pos, gain = 0.05, max_hear_distance = 1.5})
			if math.random(1,13) == 8 then
				local rnd = math.random(0,1)*-1
				minetest.add_particle(pos, {x=0.1*rnd, y=0.8, z=-0.1*rnd}, {x=-0.5*rnd, y=0.2, z=0.5*rnd}, 1.7,
   				1.2, true, "default_lava_particle.png")
			end
end})

--
-- Flowing water sound
--

minetest.register_abm({
	nodenames = {"default:water_flowing"},
	interval = 1.8,
	chance = 1.5,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.sound_play("default_water", {pos = pos, gain = 0.025, max_hear_distance = 2})
end})
