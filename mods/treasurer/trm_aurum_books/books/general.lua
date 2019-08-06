local S = minetest.get_translator()
local R = trm_aurum_books.register
local C = trm_aurum_books.categories

R{
	data = {
		author = "Rauldbien Irenphicht",
		title = S"Record of Mana",
		text = S
[[The mana moves in a cycle.
It originates in many places, some in the iron, in the bones, and in the life.
It is taken by life from iron, from the bones, and from other life.
When the life dies, the mana returns to iron surrounding the corpse, bones of the decaying flesh, and that life which consumes the remains.

Gruesome.]],
	},
	groups = C("general"),
}

R{
	data = {
		author = "Freas Blonwin",
		title = S"Siphon Discovered",
		text = S"I have taken up the Siphon. Darkness has come to haunt me, but the weapon is too strong. I advise all! Do not these ancient instruments of cruelty lest you fall victim to karma.",
	},
	groups = C("general"),
}

R{
	data = {
		author = "Niodyasto Vatesai",
		title = S"Found Something",
		text = S"It's a siphon. Good weapon. I feel powerful. There are marks on the hilt from a hand twice as big as mine. I give it an iron out of gold rating.",
	},
	groups = C("general"),
}
