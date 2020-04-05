# Digging
For tools, group number is a level rating, from 3 to 1.
* `dig_pick=x`: Pickaxe.
* `dig_chop=x`: Machete.
* `dig_dig=x`: Shovel.
* `dig_handle=x`: Hand.
* `dig_long_handle=x`: For nodes that should always be diggable, but should take a *long* time.
* `dig_snap=x`: Machete/hand.
* `dig_hammer=x`: Rare, for nodes that can be dug by hammer and will drop something different.
	* The drop is defined in `_hammer_drop`.

## Levels
Toughless levels range from 0 to 3.
* 0: Hand/Stone
* 1: Copper/Bronze
* 2: Iron/Steel
* 3: Gold (when enchanted)

# Biomes
* `aurum:aurum`: The biome's realm will be added as a group.
* `barren`: Devoid of life.
* `green`: Living, green. Plant life.
* `desert`: This is a desert biome.
* `clay`: This is a clay biome.

# Damage
## Physical
* `impact`: Crushing blows. Good damage against most targets. Should suffer penalty underwater, against very tough enemies, or against the incorporeal.
* `blade`: Less damage than impact, faster, no penalties except against armour.
* `pierce`: Pierces armor.

## Elemental
* `burn`: Heat/light.
* `chill`: Cold/dark.
* `psyche`: Mental/magic.

# Crafting
* `bone=1`: This item is a type of bone/skeleton.
* `clay=1`: This item is clay.
* `color_X=1`: This item provides/is color X.
* `dye=1`: This item is dye.
* `dye_source=1`: This item is dye source.
* `equipment=1`: For equipment.
* `glass=1`: This item is glass.
* `raw_meat=1`: Some type of raw flesh.
* `rod=1`: For rods.
* `stick=1`: For sticks. The doc modpack semi-requires a stick group.
* `tool=1`: For tools.

# Interaction
* `flammable=1`: This node can burn.
* `book=1`: This node is a paper book.
* `cook_temp=x`: This node can only be cooked in a cooker with a temperature range including x.
	* `Smelter`: 10-20
	* `Flare Oven`: 0-10
* `cook_xmana=x`: This node provides up to x mana when smelted.
* `cools_lava=1`: This node cools lava to aurum_base:stone.
	* An alternative node can be specified in `_lava_cool_node` in the lava's def.
* `dirt_base=1`: This node can be replaced by dirt spreaders.
* `dirt_smother=1`: This node will be replaced by dirt if an opaque block is on top of it.
* `dirt_spread=1`: This node will spread to nodes with light.
* `edible=x`: This node will provide x nutrition.
* `edible_morale=x`: This node will add an x (1-3) morale effect for 10 minutes.
* `fertilizer=x`: This fertilizer will turn the soil under it into fertile soil of level x when placed and right-clicked with a shovel.
* `flora=1`: This node will spread to soil or `_flora_spread_node` in def.
	* If `_on_flora_spread(pos, node)` is defined, then it will be called before the actual spreading. If it returns false, spread will be cancelled.
	* It may return a second node name for the node to spread.
* `grass_soil=1`: This node is grassy soil.
* `grow_plant=1`: This node has an `_on_grow_plant(pos, node)` function defined.
	* `_on_grow_plant` returns true if the plant grew and false if it did not.
* `igniter=1`: This node ignites fire.
* `item_burn=1`: This node destroys items that fall inside.
* `ladder=1`: This node is a ladder.
* `lava=1`: This node is lava.
* `leafdecay=x`: This node will decay and drop items if it is >x nodes away from a group:tree.
* `leaves=1`: This node is leaves.
* `liquid=1`: This node is liquid.
* `ore_block=1`: This is an ore block.
* `paper=1`: This item is made of paper and can burn.
* `sand=1`: This node is sand.
* `sapling=1`: This node is a sapling.
* `scroll=1`: This item is a scroll.
* `snow=1`: This node is snow.
* `soil=1`: Things may grow here.
* `soil_wet=x`: This soil is fertile and crops of level x or lower can grow here.
	* `This soil will dry out into dirt if not near group:water.`
* `stone=1`: This node is stone.
* `storage=x`: This node can store x stacks.
* `tree=1`: This node is a tree trunk.
* `water=1`: This node is water.
* `wood=1`: This node is wood (planks).

# Treasurer
* `dye`
* `equipment`: Equippable items such as armor.
* `enchant`: Enchanted/enchanting items.
* `enchantable`: Enchantable tools/equips.
* `lore`: An item containing lore.
	* `lore_<realm>`: Pertaining to <realm>. Can be "general" for all realms.
	* `lorebook`: Specifically in written form.
		* `lorebook_<realm>`
* `magic`: All magic items.
* `processed`: Processed items such as ingots.
* `raw`: Natural, unprocessed items.
* `scroll`: Scrolls, magic paper.
	* `enchant_scroll`: Specifically enchantments.
* `spell`: Spell or bespelled item.
* `worker`: Such as smelter or enchanting table.
