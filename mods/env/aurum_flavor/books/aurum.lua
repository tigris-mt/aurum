local S = minetest.get_translator()
local R = aurum.flavor.books.register
local C = aurum.flavor.books.categories

R{
	data = {
		author = "Clozar Dutagrav",
		title = S"The Graves of Aurum",
		text = S[[There was a time when the living numbered more than the dead they buried. But now the darkess weaves ever closer, and the remnants of ancient populaces lie beneath the earth and ice.
We do not remember them. Who will? There is only one: the merciless, inexorable Headstoner. To her the reaper renders his prey. She is no replacement for the warmth we have lost.]]
	},
	groups = C("aurum"),
}
