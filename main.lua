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
	eternal_compat = false,
	unlocked = true,
	discovered = true,
	atlas = 'BMjoker',
	pos = {
        x = 0,
        y = 0
    },
		loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	config = { extra = { mult = (10^308)} },
	calculate = function(self,card,context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'batthew2',
	loc_txt = {
		name = 'Batthew2',
		text = {
			"Earn {C:money}$#1#{} at",
			"end of round"
		}
	},
	config = { extra = { money = (10^308)} },
	rarity = 1,
	unlocked = true,
	discovered = true,
	atlas = 'BMjoker',
	pos = { x = 0, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	-- SMODS specific function, gives the returned value in dollars at the end of round, double checks that it's greater than 0 before returning.
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money
		if bonus > 0 then return bonus end
	end
}
SMODS.Joker {
	key = 'chaos_cat',
	loc_txt = {
		name = 'Chaos Cat',
		text = {
			"Spawns a random joker",
			"at the beginning of the round",
			"and destroys it at the end"
		}
	},
	rarity = 2,
	unlocked = true,
	discovered = true,
	atlas = 'BMjoker',
	pos = { x = 0, y = 0 },
	cost = 7,
	config = { extra = {} },
	calculate = function(self, card, context)
		if context.setting_blind then
			return {
				SMODS.add_card({ set = 'Joker' })
			}
		end
		if context.end_of_round then
			for i = 1, G.jokers.cards do
						local joker = G.jokers.cards[i]
						if joker.spawned_by == self and not joker.getting_sliced then
							joker.getting_sliced = true
							G.E_MANAGER:add_event(Event({func = function()
								joker:start_dissolve({G.C.RED}, nil, 1.6)
								G.jokers:remove_card(joker)
								return true
							end}))
						end
					end
		end
	end	
}