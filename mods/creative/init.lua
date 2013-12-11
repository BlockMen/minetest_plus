creative = {}
creative.creative_inventory_size = 0

function init()
 local inv = minetest.create_detached_inventory("creative", {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			if minetest.setting_getbool("creative_mode") then
				return count
			else
				return 0
			end
		end,
		allow_put = function(inv, listname, index, stack, player)
			print(stack:get_name())
			local slot = inv:get_stack(listname, index)
				print(slot:get_name())
			if stack and slot then
				if stack:get_name() == slot:get_name() then
					inv:set_stack(listname,index,{name=stack:get_name(), count = 2})
				return 2
				end
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			if minetest.setting_getbool("creative_mode") then
				return -1
			else
				return 0
			end
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
		end,
		on_put = function(inv, listname, index, stack, player)
		end,
		on_take = function(inv, listname, index, stack, player)
			print(player:get_player_name().." takes item from creative inventory; listname="..dump(listname)..", index="..dump(index)..", stack="..dump(stack))
			if stack then
				print("stack:get_name()="..dump(stack:get_name())..", stack:get_count()="..dump(stack:get_count()))
			end
		end,
	})
 set_inv("all")
end

function set_inv(filter, player)
	local inv = minetest.get_inventory({type="detached", name="creative"})
	inv:set_size("main", 0)
	local creative_list = {}
	for name,def in pairs(minetest.registered_items) do
		if (not def.groups.not_in_creative_inventory or def.groups.not_in_creative_inventory == 0) and def.description and def.description ~= "" then
			if filter ~= "" then
				if filter == "#blocks" then
					if def.walkable == true then
						table.insert(creative_list, name)
					end
				elseif filter == "#deco" then
					if (def.walkable == false or def.drawtype == "plantlike" or def.drawtype == "allfaces_optional" or string.find(string.lower(def.description), "torch") or string.find(string.lower(def.description), "door")) and not string.find(string.lower(def.description), "apple") then--def.groups. == true then
						table.insert(creative_list, name)
					end
				elseif filter == "#misc" then
					if def.drawtype == nil and def.type ~= "tool" and not string.find(string.lower(def.description), "torch") and not string.find(string.lower(def.description), "bread") and not string.find(string.lower(def.description), "door") then
						table.insert(creative_list, name)
					end
				elseif filter == "#food" then
					if def.groups.food ~= nil or string.find(string.lower(def.description), "apple") or string.find(string.lower(def.description), "bread") then
						table.insert(creative_list, name)
					end
				elseif filter == "#tools" then
					if def.type == "tool" then
						table.insert(creative_list, name)
					end
				elseif filter == "all" then
					table.insert(creative_list, name)
				else --for all other
					if string.find(string.lower(def.name), filter) or string.find(string.lower(def.description), filter) then
						table.insert(creative_list, name)
					end
				end
			end
		end
	end
	table.sort(creative_list)
	inv:set_size("main", #creative_list)
	for _,itemstring in ipairs(creative_list) do
		inv:add_item("main", ItemStack(itemstring))
	end
	creative.creative_inventory_size = #creative_list
	--print("creative inventory size: "..dump(creative.creative_inventory_size))
end

-- Create the trash field
local trash = minetest.create_detached_inventory("creative_trash", {
	allow_put = function(inv, listname, index, stack, player)
		if minetest.setting_getbool("creative_mode") then
			return stack:get_count()
		else
			return 0
		end
	end,
	on_put = function(inv, listname, index, stack, player)
		inv:set_stack(listname, index, "")
	end,
})
trash:set_size("main", 1)


-- Create detached creative inventory after loading all mods
minetest.after(0, init)

local offset = {}
local bg = {}
offset["nix"] = "-0.29,-0.27"
offset["build"] = "0.979,-0.27"
offset["other"] = "2.24,-0.27"
offset["tools"] = "3.5,-0.27"
offset["misc"] = "4.79,-0.27"
offset["food"] = "6.05,-0.27"
offset["inv"] = "8,-0.27"

local function reset_menu_item_bg()
	bg["nix"] = "creative_bg_dark.png"
	bg["build"] = "creative_bg_dark.png"
	bg["other"] = "creative_bg_dark.png"
	bg["tools"] = "creative_bg_dark.png"
	bg["misc"] = "creative_bg_dark.png"
	bg["food"] = "creative_bg_dark.png"
	bg["inv"] = "creative_bg_dark.png"
end

creative.set_creative_formspec = function(player, start_i, pagenum, show, page)
	reset_menu_item_bg()
	pagenum = math.floor(pagenum)
	local pagemax = math.floor((creative.creative_inventory_size-1) / (8*5) + 1)
	local slider_height = 4/pagemax
	local slider_pos = slider_height*(pagenum-1)+2.24
	local name = "nix"
	local formspec = ""
	local main_list = "list[detached:creative;main;0,1.75;8,5;"..tostring(start_i).."]"--"list[current_player;main;0,3.75;9,3;8]"--..
	if page ~= nil then name = page end
		bg[name] = "creative_bg.png"
		if name == "inv" then
			main_list = "image[-0.2,1.7;10.1,2.33;creative_bg.png]"..
				"list[current_player;main;0,3.75;8,3;8]"
		end
		formspec = "size[9,8.3]"..
			"label[-5,-5;"..name.."]"..
			"image[" .. offset[name] .. ";1.5,1.44;creative_active.png]"..
			"image_button[-0.1,-0.05;1,1;"..bg["nix"].."^creative_all.png;default;]"..	--nix+search
			"image_button[1.154,-0.05;1,1;"..bg["build"].."^creative_build.png;build;]"..	--decoration blocks
			"image_button[2.419,-0.05;1,1;"..bg["other"].."^creative_other.png;other;]"..	--redstone
			"image_button[3.7,-0.05;1,1;"..bg["tools"].."^creative_tool.png;tools;]"..	--transportation
			"image_button[4.95,-0.05;1,1;"..bg["misc"].."^creative_misc.png;misc;]"..	--miscellaneous
			"image_button[6.25,-0.05;1,1;"..bg["food"].."^creative_food.png;food;]"..	--food
			"image_button[8.19,-0.05;1,1;"..bg["inv"].."^creative_inv.png;inv;]"..		--inv
			"image[0,1;5,0.75;fnt_"..name..".png]"..
			main_list..
			"list[current_player;main;0,7;8,1;]"..
			"background[-0.19,-0.25;9.53,8.54;creative_inventory.png]"..
			"image_button[8.03,1.74;0.85,0.6;creative_up.png;creative_prev;]"..
			"image[8.04," .. tostring(slider_pos) .. ";0.75,"..tostring(slider_height) .. ";creative_slider.png]"..
			"image_button[8.03,6.15;0.85,0.6;creative_down.png;creative_next;]"..
			"list[detached:creative_trash;main;8,7;1,1;]"..
			"image[8,7;1,1;creative_trash.png]"..
			"bgcolor[#000A;true]"..
			"listcolors[#9990;#FFF7;#FFF0;#160816;#9E9D9E]"
			if page == nil then formspec = formspec .. "field[5.3,1.3;3,0.75;suche;;]" end
	player:set_inventory_formspec(formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local page = nil
	if not minetest.setting_getbool("creative_mode") then
		return
	end
	
	if fields.suche ~= nil and fields.suche ~= "" then
		set_inv(string.lower(fields.suche))
		minetest.after(0.5, function()
			minetest.show_formspec(player:get_player_name(), "detached:creative",  player:get_inventory_formspec())
		end)
	end

	if fields.build then		
		set_inv("#blocks",player)
		page = "build"		
	end
	if fields.other then		
		set_inv("#deco",player)
		page = "other"
	end
	if fields.misc then		
		set_inv("#misc",player)
		page = "misc"
	end
	if fields.default then		
		set_inv("all")
		page = nil
	end
	if fields.food then		
		set_inv("#food")
		page = "food"
	end
	if fields.tools then		
		set_inv("#tools")
		page = "tools"
	end
	if fields.inv then
		page = "inv"
	end
	-- Figure out current page from formspec
	local current_page = 0
	local formspec = player:get_inventory_formspec()

	local start_i = string.match(formspec, "list%[detached:creative;main;[%d.]+,[%d.]+;[%d.]+,[%d.]+;(%d+)%]")
	local bis = string.find (formspec, "image") or 2
	local tmp_page = string.sub(formspec, 24, bis-2)
	if tmp_page == "nix" then tmp_page = nil end
	start_i = tonumber(start_i) or 0
	if fields.creative_prev then
		start_i = start_i - 8*5
		page = tmp_page
	end
	if fields.creative_next then
		start_i = start_i + 8*5
		page = tmp_page
	end
	if start_i < 0 then
		start_i = start_i + 8*5
	end
	if start_i >= creative.creative_inventory_size then
		start_i = start_i - 8*5
	end		
	if start_i < 0 or start_i >= creative.creative_inventory_size then
		start_i = 0
	end
	creative.set_creative_formspec(player, start_i, start_i / (8*5) + 1, false, page)
end)


if minetest.setting_getbool("creative_mode") then
	
	minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
		return true
	end)
	
	function minetest.handle_node_drops(pos, drops, digger)
		if not digger or not digger:is_player() then
			return
		end
		local inv = digger:get_inventory()
		if inv then
			for _,item in ipairs(drops) do
				item = ItemStack(item):get_name()
				if not inv:contains_item("main", item) then
					inv:add_item("main", item)
				end
			end
		end
	end
	
end
