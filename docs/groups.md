# Digging
For tools, group number is a level rating, from 3 to 1.
* `dig_pick=x`: Pickaxe.
* `dig_chop=x`: Machete.
* `dig_dig=x`: Shovel.
* `dig_handle=x`: Hand.
* `dig_snap=x`: Machete/hand.
* `dig_hammer=x`: Rare, for nodes that can be dug by hammer and will drop something different.
	* The drop is defined in `_hammer_drop`.

## Levels
Toughless levels range from 0 to 3.
* 0: Hand/Stone
* 1: Copper/Bronze
* 2: Iron/Steel
* 3: Gold (when enchanted)

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
* `equipment`: For equipment.
* `stick`: For sticks. The doc modpack semi-requires a stick group.
* `tool`: For tools.

# Interaction
* `flammable=1`: This node can burn.
* `cook_temp=x`: This node can only be cooked in a cooker with a temperature range including x.
	* `Smelter`: 10-20
	* `Flare Box`: 0-10
* `cook_xmana=x`: This node provides up to x mana when smelted.
* `cools_lava=1`: This node cools lava to aurum_base:stone.
	* An alternative node can be specified in `_lava_cool_node` in def.
* `dirt_base=1`: This node can be replaced by dirt spreaders.
* `dirt_smother=1`: This node will be replaced by dirt if an opaque block is on top of it.
* `dirt_spread=1`: This node will spread to nodes with light.
* `grow_plant=1`: This node has an _on_grow_plant(pos, node) function defined.
* `item_burn=1`: This node destroys items that fall inside.
* `lava=1`: This node is lava.
* `leafdecay=x`: This node will decay and drop items if it is >x nodes away from a group:tree.
* `leaves=1`: This node is leaves.
* `liquid=1`: This node is liquid.
* `sapling=1`: This node is a sapling.
* `soil=1`: Things may grow here.
* `tree=1`: This node is a tree trunk.
* `water=1`: This node is water.
* `wood=1`: This node is wood (planks).
