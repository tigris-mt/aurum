aurum.base = {}

-- Dirt behaviour.
b.dofile("dirt.lua")

-- Base/ground nodes.
b.dofile("base.lua")
b.dodir("liquids")

-- Base building blocks, crafted.
b.dofile("building_blocks.lua")

-- Sticks.
b.dofile("sticks.lua")
-- Organic paste.
b.dofile("paste.lua")

-- Lava behaviour.
b.dofile("lava_cooling.lua")
