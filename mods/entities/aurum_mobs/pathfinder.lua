aurum.mobs.PATHMETHOD_WALK = b.pathfinder.require_pathfinder(b.set{
	aurum.mobs.CHEAP and "cheap" or "any",
	"specify_vertical",
	"node_functions_walkable",
	"node_functions_passable",
	"clearance_height",
})

aurum.mobs.PATHMETHOD_FLY = b.pathfinder.require_pathfinder(b.set{
	aurum.mobs.CHEAP and "cheap" or "any",
	"specify_vertical",
	"node_functions_walkable",
	"node_functions_passable",
	"clearance_height",
})

aurum.mobs.PATHMETHOD_SWIM = b.pathfinder.require_pathfinder(b.set{
	aurum.mobs.CHEAP and "cheap" or "any",
	"specify_vertical",
	"node_functions_walkable",
	"node_functions_passable",
	"clearance_height",
})

aurum.mobs.DEFAULT_PATHFINDER = {
	method = aurum.mobs.PATHMETHOD_WALK,
	search_distance = 48,
	jump_height = 2,
	drop_height = 3,
}

aurum.mobs.DEFAULT_FLY_PATHFINDER = {
	method = aurum.mobs.PATHMETHOD_FLY,
	search_distance = 48,
	jump_height = -5,
	drop_height = -1,
	node_walkable = function() return true end,
}

aurum.mobs.DEFAULT_SWIM_PATHFINDER = {
	method = aurum.mobs.PATHMETHOD_SWIM,
	search_distance = 48,
	jump_height = -5,
	drop_height = -1,
	node_passable = function(_, node) return (minetest.registered_nodes[node.name].liquidtype or "none") ~= "none" or not minetest.registered_nodes[node.name].walkable end,
	node_walkable = function(_, node) return (minetest.registered_nodes[node.name].liquidtype or "none") ~= "none" or minetest.registered_nodes[node.name].walkable end,
}
