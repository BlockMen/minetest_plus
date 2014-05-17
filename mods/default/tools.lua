-- mods/default/tools.lua

-- The hand
minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=6.70,[2]=4.00,[3]=1.40,[4]=30.00}, uses=0, maxlevel=3}
		},
		damage_groups = {fleshy=1},
	}
})

--
-- Picks
--

minetest.register_tool("default:pick_wood", {
	description = "Wooden Pickaxe",
	inventory_image = "default_tool_woodpick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=1.40}, uses=10/3, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:pick_stone", {
	description = "Stone Pickaxe",
	inventory_image = "default_tool_stonepick.png",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=1.80, [3]=1.15}, uses=20/3, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("default:pick_steel", {
	description = "Steel Pickaxe",
	inventory_image = "default_tool_steelpick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=3.50, [2]=1.50, [3]=0.80}, uses=20/3, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("default:pick_bronze", {
	description = "Bronze Pickaxe",
	inventory_image = "default_tool_bronzepick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=30/3, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("default:pick_mese", {
	description = "Mese Pickaxe",
	inventory_image = "default_tool_mesepick.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=20/3, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})
minetest.register_tool("default:pick_diamond", {
	description = "Diamond Pickaxe",
	inventory_image = "default_tool_diamondpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=30/3, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})

--
-- Shovels
--

minetest.register_tool("default:shovel_wood", {
	description = "Wooden Shovel",
	inventory_image = "default_tool_woodshovel.png",
	wield_image = "default_tool_woodshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=2.80, [2]=1.50, [3]=0.60}, uses=10/3, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:shovel_stone", {
	description = "Stone Shovel",
	inventory_image = "default_tool_stoneshovel.png",
	wield_image = "default_tool_stoneshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=1.80, [2]=1.20, [3]=0.50}, uses=20/3, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:shovel_steel", {
	description = "Steel Shovel",
	inventory_image = "default_tool_steelshovel.png",
	wield_image = "default_tool_steelshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=30/3, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("default:shovel_bronze", {
	description = "Bronze Shovel",
	inventory_image = "default_tool_bronzeshovel.png",
	wield_image = "default_tool_bronzeshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=40/3, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("default:shovel_mese", {
	description = "Mese Shovel",
	inventory_image = "default_tool_meseshovel.png",
	wield_image = "default_tool_meseshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=1.20, [2]=0.60, [3]=0.30}, uses=20/3, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("default:shovel_diamond", {
	description = "Diamond Shovel",
	inventory_image = "default_tool_diamondshovel.png",
	wield_image = "default_tool_diamondshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=30/3, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})

--
-- Axes
--

minetest.register_tool("default:axe_wood", {
	description = "Wooden Axe",
	inventory_image = "default_tool_woodaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=2.60, [3]=1.80}, uses=10/3, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("default:axe_stone", {
	description = "Stone Axe",
	inventory_image = "default_tool_stoneaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			choppy={times={[1]=3.00, [2]=2.00, [3]=1.50}, uses=20/3, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("default:axe_steel", {
	description = "Steel Axe",
	inventory_image = "default_tool_steelaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=20/3, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("default:axe_bronze", {
	description = "Bronze Axe",
	inventory_image = "default_tool_bronzeaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.50, [2]=1.40, [3]=1.00}, uses=30/3, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("default:axe_mese", {
	description = "Mese Axe",
	inventory_image = "default_tool_meseaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=20/3, maxlevel=3},
		},
		damage_groups = {fleshy=6},
	},
})
minetest.register_tool("default:axe_diamond", {
	description = "Diamond Axe",
	inventory_image = "default_tool_diamondaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=30/3, maxlevel=2},
		},
		damage_groups = {fleshy=7},
	},
})

--
-- Swords
--

minetest.register_tool("default:sword_wood", {
	description = "Wooden Sword",
	inventory_image = "default_tool_woodsword.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=1.6, [3]=0.40}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	}
})
minetest.register_tool("default:sword_stone", {
	description = "Stone Sword",
	inventory_image = "default_tool_stonesword.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=1.4, [3]=0.40}, uses=20/3, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	}
})
minetest.register_tool("default:sword_steel", {
	description = "Steel Sword",
	inventory_image = "default_tool_steelsword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30/3, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	}
})
minetest.register_tool("default:sword_bronze", {
	description = "Bronze Sword",
	inventory_image = "default_tool_bronzesword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=40/3, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	}
})
minetest.register_tool("default:sword_mese", {
	description = "Mese Sword",
	inventory_image = "default_tool_mesesword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.0, [2]=1.00, [3]=0.35}, uses=30/3, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	}
})
minetest.register_tool("default:sword_diamond", {
	description = "Diamond Sword",
	inventory_image = "default_tool_diamondsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40/3, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	}
})

--
-- Hoes
--

minetest.register_tool("default:hoe_wood", {
	description = "Wooden Hoe",
	inventory_image = "default_tool_woodhoe.png",
	
	on_use = function(itemstack, user, pointed_thing)
		return default.hoe_on_use(itemstack, user, pointed_thing, 30)
	end,
})

minetest.register_tool("default:hoe_stone", {
	description = "Stone Hoe",
	inventory_image = "default_tool_stonehoe.png",
	
	on_use = function(itemstack, user, pointed_thing)
		return default.hoe_on_use(itemstack, user, pointed_thing, 90)
	end,
})

minetest.register_tool("default:hoe_steel", {
	description = "Steel Hoe",
	inventory_image = "default_tool_steelhoe.png",
	
	on_use = function(itemstack, user, pointed_thing)
		return default.hoe_on_use(itemstack, user, pointed_thing, 200)
	end,
})

minetest.register_tool("default:hoe_bronze", {
	description = "Bronze Hoe",
	inventory_image = "default_tool_bronzehoe.png",
	
	on_use = function(itemstack, user, pointed_thing)
		return default.hoe_on_use(itemstack, user, pointed_thing, 220)
	end,
})

minetest.register_tool("default:hoe_mese", {
	description = "Mese Hoe",
	inventory_image = "default_tool_mesehoe.png",
	
	on_use = function(itemstack, user, pointed_thing)
		return default.hoe_on_use(itemstack, user, pointed_thing, 350)
	end,
})

minetest.register_tool("default:hoe_diamond", {
	description = "Diamond Hoe",
	inventory_image = "default_tool_diamondhoe.png",
	
	on_use = function(itemstack, user, pointed_thing)
		return default.hoe_on_use(itemstack, user, pointed_thing, 500)
	end,
})

--armor
-- Regisiter Head Armor

minetest.register_tool("default:armor_helmet_wood", {
	description = "Wood Helmet",
	inventory_image = "default_armor_inv_helmet_wood.png",
	groups = {armor_head=5, armor_heal=0, armor_use=2000},
	wear = 0,
})

minetest.register_tool("default:armor_helmet_steel", {
	description = "Steel Helmet",
	inventory_image = "default_armor_inv_helmet_steel.png",
	groups = {armor_head=10, armor_heal=2, armor_use=500},
	wear = 0,
})

minetest.register_tool("default:armor_helmet_bronze", {
	description = "Bronze Helmet",
	inventory_image = "default_armor_inv_helmet_bronze.png",
	groups = {armor_head=10, armor_heal=6, armor_use=250},
	wear = 0,
})

minetest.register_tool("default:armor_helmet_diamond", {
	description = "Diamond Helmet",
	inventory_image = "default_armor_inv_helmet_diamond.png",
	groups = {armor_head=15, armor_heal=12, armor_use=100},
	wear = 0,
})

-- Regisiter Torso Armor

minetest.register_tool("default:armor_chestplate_wood", {
	description = "Wood Chestplate",
	inventory_image = "default_armor_inv_chestplate_wood.png",
	groups = {armor_torso=10, armor_heal=0, armor_use=2000},
	wear = 0,
})

minetest.register_tool("default:armor_chestplate_steel", {
	description = "Steel Chestplate",
	inventory_image = "default_armor_inv_chestplate_steel.png",
	groups = {armor_torso=15, armor_heal=2, armor_use=500},
	wear = 0,
})

minetest.register_tool("default:armor_chestplate_bronze", {
	description = "Bronze Chestplate",
	inventory_image = "default_armor_inv_chestplate_bronze.png",
	groups = {armor_torso=15, armor_heal=6, armor_use=250},
	wear = 0,
})

minetest.register_tool("default:armor_chestplate_diamond", {
	description = "Diamond Chestplate",
	inventory_image = "default_armor_inv_chestplate_diamond.png",
	groups = {armor_torso=20, armor_heal=12, armor_use=100},
	wear = 0,
})

-- Regisiter Leg Armor

minetest.register_tool("default:armor_leggings_wood", {
	description = "Wood Leggings",
	inventory_image = "default_armor_inv_leggings_wood.png",
	groups = {armor_legs=5, armor_heal=0, armor_use=2000},
	wear = 0,
})

minetest.register_tool("default:armor_leggings_steel", {
	description = "Steel Leggings",
	inventory_image = "default_armor_inv_leggings_steel.png",
	groups = {armor_legs=15, armor_heal=2, armor_use=500},
	wear = 0,
})

minetest.register_tool("default:armor_leggings_bronze", {
	description = "Bronze Leggings",
	inventory_image = "default_armor_inv_leggings_bronze.png",
	groups = {armor_legs=15, armor_heal=6, armor_use=250},
	wear = 0,
})

minetest.register_tool("default:armor_leggings_diamond", {
	description = "Diamond Leggings",
	inventory_image = "default_armor_inv_leggings_diamond.png",
	groups = {armor_legs=20, armor_heal=12, armor_use=100},
	wear = 0,
})

-- Regisiter Boots

minetest.register_tool("default:armor_boots_wood", {
	description = "Wood Boots",
	inventory_image = "default_armor_inv_boots_wood.png",
	groups = {armor_feet=5, armor_heal=0, armor_use=2000},
	wear = 0,
})

minetest.register_tool("default:armor_boots_steel", {
	description = "Steel Boots",
	inventory_image = "default_armor_inv_boots_steel.png",
	groups = {armor_feet=10, armor_heal=2, armor_use=500},
	wear = 0,
})

minetest.register_tool("default:armor_boots_bronze", {
	description = "Bronze Boots",
	inventory_image = "default_armor_inv_boots_bronze.png",
	groups = {armor_feet=10, armor_heal=6, armor_use=250},
	wear = 0,
})

minetest.register_tool("default:armor_boots_diamond", {
	description = "Diamond Boots",
	inventory_image = "default_armor_inv_boots_diamond.png",
	groups = {armor_feet=15, armor_heal=12, armor_use=100},
	wear = 0,
})


-- Register Craft Recipies  default:armor_helmet_wood

local craft_ingreds = {
	wood = "group:wood",
	steel = "default:steel_ingot",
	bronze = "default:bronze_ingot",
	diamond = "default:diamond",
}

for k, v in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "default:armor_helmet_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "default:armor_chestplate_"..k,
		recipe = {
			{v, "", v},
			{v, v, v},
			{v, v, v},
		},
	})
	minetest.register_craft({
		output = "default:armor_leggings_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{v, "", v},
		},
	})
	minetest.register_craft({
		output = "default:armor_boots_"..k,
		recipe = {
			{v, "", v},
			{v, "", v},
		},
	})
end


