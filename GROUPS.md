# Digging
For tools, group number is a level rating, from 3 to 1.
* `dig_pick=x`: Pickaxe.
* `dig_chop=x`: Machete.
* `dig_shovel=x`: Shovel.
* `dig_hand=x`: Hand.

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
* `grow_plant=1`: This node has a _on_grow_plant(pos, node) function defined.
* `leafdecay=x`: This node will decay and drop items if it is >x nodes away from a group:tree.
* `leaves=1`: This node is leaves.
* `sapling=1`: This node is a sapling.
* `soil=1`: Things may grow here.
* `tree=1`: This node is part of a tree (trunk or branch).
* `wood=1`: This node is wood (planks).
