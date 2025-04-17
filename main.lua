SMODS.Atlas{
	key = "BMjoker",
	path = "BMjoker.png",
	px = 71,
	py = 95
}

SMODS.Joker{
	key = "batthew",
	name = "Batthew",
	loc_txt = {
		['name'] = 'Batthew',
		['text'] = {
			"{C:mult}+#1# {} Mult"
		}
	},
	cost = 5,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	unlocked = true,
	discovered = true,
	atlas = 'BMJoker',
	pos = {
        x = 0,
        y = 0
    },
	config = { extra = { mult = 20 } },
	calculate = function(self,card,context)
		if context.joker.main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
	end
}