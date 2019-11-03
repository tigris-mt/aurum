function aurum.mobs.helper_find_nodes(self, nodes)
	print(dump(nodes))
end

gemai.register_action("aurum_mobs:find_habitat", function(self)
	aurum.mobs.helper_find_nodes(self, self.entity._aurum_mob.habitat_nodes)
end)
