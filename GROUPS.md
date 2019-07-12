# Digging
For tools, group number is a level rating, from 3 to 1.
* `dig_pick=x`: Pickaxe.
* `dig_chop=x`: Machete.
* `dig_dig=x`: Shovel.
* `dig_handle=x`: Hand.
* `dig_snap=x`: Machete/hand.
* `dig_hammer=x`: Rare, for nodes that can be dug by hammer (and probably will drop something different).

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

# Interaction
* `flammable=1`: This node can burn.
* `grow_plant=1`: This node has an _on_grow_plant(pos, node) function defined.
* `leafdecay=x`: This node will decay and drop items if it is >x nodes away from a group:tree.
* `leaves=1`: This node is leaves.
* `sapling=1`: This node is a sapling.
* `soil=1`: Things may grow here.
* `tree=1`: This node is part of a tree (trunk or branch).
* `tree_trunk=1`: This node is specifically a tree trunk.
* `wood=1`: This node is wood (planks).
