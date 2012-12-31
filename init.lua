minetest.register_alias("firestone", "firestone:firestone")

local makes_fire = true -- When set true the firestone makes fire itself. When false you need to lighten it.

minetest.register_craft({
	output = '"firestone:firestone" 1',
	recipe = {
		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
		{'default:coal_lump', 'default:torch', 'default:coal_lump'},
		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
	}
})

if makes_fire == true then

minetest.register_node("firestone:firestone", {
	description = "Fire node",
	tile_images = {"firestone_firestone_top.png^firestone_embers.png", "firestone_firestone_bottom.png", "firestone_firestone.png"},
	groups = {igniter=2, crumbly=3},
	damage_per_second = 4,
	
	after_place_node = function(pos)
	    local t = {x=pos.x, y=pos.y+1, z=pos.z}
	    local n = minetest.env:get_node(t)
        if n.name == "air" then
		    minetest.env:add_node(t, {name="firestone:flame"})
		end
	end,

	after_dig_node = function(pos)
		local t = {x=pos.x, y=pos.y+1, z=pos.z}
	    local n = minetest.env:get_node(t)
        if n.name == "firestone:flame" or n.name == "firestone:flame_low" then
		    minetest.env:remove_node(t)
		end
	end,
	
})

else

minetest.register_node("firestone:firestone", {
	description = "Fire node",
	tile_images = {"firestone_firestone_top.png^firestone_embers.png", "firestone_firestone_bottom.png", "firestone_firestone.png"},
	groups = {crumbly=3},
	damage_per_second = 4,

	after_dig_node = function(pos)
		local t = {x=pos.x, y=pos.y+1, z=pos.z}
	    local n = minetest.env:get_node(t)
        if n.name == "firestone:flame" or n.name == "firestone:flame_low" then
		    minetest.env:remove_node(t)
		end
	end,
	
})

end

minetest.register_node("firestone:flame", {
	description = "Fire",
	drawtype = "plantlike",
	tiles = {{
		name="fire_basic_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "fire_basic_flame.png",
	light_source = 14,
	groups = {igniter=2, immortal, not_in_creative_inventory=1, dig_immediate=3},
	drop = '',
	walkable = false,
	buildable_to = true,
	damage_per_second = 4,
})

minetest.register_node("firestone:flame_low", {
	description = "Fire",
	drawtype = "plantlike",
	tiles = {{
		name="fire_basic_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "fire_basic_flame.png",
	light_source = 12,
	groups = {igniter=2, immortal, not_in_creative_inventory=1, dig_immediate=3},
	drop = '',
	walkable = false,
	buildable_to = true,
	damage_per_second = 4,
})

minetest.register_abm({
    nodenames = {"firestone:firestone"},
	interval = 2,
	chance = 5,
	action = function(pos)
		local t = {x=pos.x, y=pos.y+1, z=pos.z}
	    local n = minetest.env:get_node(t)
        if n.name == "firestone:flame_low" then
		    minetest.env:set_node(t, {name="firestone:flame"})
		elseif n.name == "firestone:flame" then
		    minetest.env:set_node(t, {name="firestone:flame_low"})
		elseif n.name == "air" and makes_fire == true then
		    minetest.env:set_node(t, {name="firestone:flame_low"})
		-- lighting the firestone
		elseif minetest.get_item_group(n.name, "igniter") ~= 0 and makes_fire == false and minetest.registered_nodes[n.name].buildable_to == true then
				minetest.env:set_node(t, {name="firestone:flame"})
		end
		
	end,

})
