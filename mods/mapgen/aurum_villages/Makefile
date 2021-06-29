all: schematics/ruined_hall_jungle.mts

schematics/ruined_hall_jungle.mts: schematics/ruined_hall.mts
	$(aurum)/tools/mts_replace.py < $< aurum_trees:drywood aurum_trees:pander > $@
