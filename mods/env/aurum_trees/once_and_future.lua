-- Run f(<name of tree>) for all trees that have been and will be registered.
function aurum.trees.once_and_future(f)
	for tree in pairs(aurum.trees.types) do
		f(tree)
	end

	local old = aurum.trees.register
	function aurum.trees.register(name, ...)
		local ret = old(name, ...)
		f(name)
		return ret
	end
end
