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
	key = 'negative_spawner',
	loc_txt = {
		name = 'Negative Spawner',
		text = {
			"Spawns a random negative joker",
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
				SMODS.add_card({ set = 'Joker',edition = 'negative', stickers = ["disposable"]  })
			}
		end
	end
}

SMODS.Sticker {

	key = "disposable",
	rate = 1,
	loc_txt = {
		label = "disposable",
		name = "Disposable",
		text = {
			"{C:green}#1# in 1{} chance this",
			"joker is destroyed",
			"at end of round"
		}
	},
	config = { extra = { odds = 6 } },
	badge_colour = HEX('ADB200'),
	needs_enable_flag = false,
	
	should_apply = function(self,card,center,area,bypass_roll)
		local yes = SMODS.Sticker.should_apply(self,card,center,area,bypass_roll)
		
		if G.GAME.modifiers.enable_eternals_in_shop then
			yes = false
		end
		
		return yes
	end,
	
	loc_vars = function(self, info_queue, card)
		return { vars = {G.GAME.probabilities.normal or 1}}
	end,
	
	
	calculate = function(self, card, context)
		

		-- Checks to see if it's end of round, and if context.game_over is false.
		-- Also, not context.repetition ensures it doesn't get called during repetitions.
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if true then
				-- This part plays the animation.
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				-- Sets the pool flag to true, meaning Gros Michel 2 doesn't spawn, and Cavendish 2 does.
				
				return {
					message = 'Extinct!'
				}
			else
				return {
					message = 'Safe!'
				}
			end
		end
	end
}
