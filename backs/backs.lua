local reverencedeck = {
    name = "reverencedeck",
    key = "reverencedeck",
    atlas = "backs",
    pos = {x = 0, y = 0},
    config = {},
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    apply = function(self)
        G.GAME.modifiers.poke_force_seal = "poke_silver"
    end
}

local virtuousdeck = {
	name = "virtuousdeck",
	key = "virtuousdeck",  
    atlas = "backs",
    pos = { x = 1, y = 0 },
	config = {consumables = {"c_sonfive_timerball"}, hands = -1, dollars = 0},
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end
} 

local propheticdeck ={
    name = "propheticdeck",
    key = "propheticdeck",
    atlas = "backs",
    pos = { x = 2, y = 0 },
    config = {hand_size = -1, extra = {scry = 3}},
    loc_vars = function(self, info_queue, center)
        return {vars = {self.config.hand_size, self.config.extra.scry}}
    end,

    
    apply = function(self)
        G.GAME.scry_amount = self.config.extra.scry
    end    
}

local shinydeck ={
    name = "shinydeck",
    key = "shinydeck",
    atlas = "backs",
    pos = { x = 3, y = 0 },
    config = {extra = {chance = 100}},
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,    
calculate = function(self, card, context)
    if context.setting_blind then
      print(G.GAME.shiny_edition_rate)
    end
  end,
    apply = function(self)
        local previous_shiny_get_weight = G.P_CENTERS.e_poke_shiny.get_weight
        G.P_CENTERS.e_poke_shiny.get_weight = function(self)
          return previous_shiny_get_weight(self) + ((G.GAME.shiny_edition_rate or 1) - 1) * G.P_CENTERS.e_poke_shiny.weight
        end
        G.GAME.shiny_edition_rate = (G.GAME.shiny_edition_rate or 1) * self.config.extra.chance
    end   
}

local megadeck = {
	name = "megadeck",
	key = "megadeck",  
    atlas = "backs",
    pos = { x = 4, y = 0 },
	config = {consumables = {"c_poke_megastone"}},
  loc_vars = function(self, info_queue, center)
    return {vars = {self.config.consumables}}
  end,

  apply = function(self)
    G.GAME.win_ante = (G.GAME.win_ante + 4)
  end
} 



local voiddeck = {
	name = "voiddeck",
	key = "voiddeck",  
    atlas = "backs",
    pos = { x = 5, y = 0 },
	config = {spectral_rate = 2, consumables = {"c_poke_nightmare"}},
  loc_vars = function(self, info_queue, center)
    return {vars = {"c_poke_nightmare"}}
  end,
  calculate = function(self, back, context)
    void = true
  --   if not context.repetition and not context.individual and context.end_of_round and G.GAME.last_blind and G.GAME.last_blind.boss then
  --     if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
  --     local _card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_poke_nightmare')
  --     -- local edition = {negative = true}
  --     -- _card:set_edition(edition, true)
  --     _card:add_to_deck()
  --     G.consumeables:emplace(_card)
  --     card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
  --   end
  -- end
  end,
  apply = function(self)
    void = true
  end
} 

-- local hazardousdeck = {
-- 	name = "hazardousdeck",
-- 	key = "hazardousdeck",  
--     atlas = "backs",
--     pos = { x = 6, y = 0 },
-- 	config = { extra = {hazard_ratio = 10}},
--   loc_vars = function(self, info_queue, center)
--     local hazardcount = math.floor(52/self.config.extra.hazard_ratio)
--     if G.playing_cards then 
--       hazardcount = math.floor(#G.playing_cards/self.config.extra.hazard_ratio)
--     else 
--     end
--     return {vars = {self.config.jokers, self.config.extra.hazard_ratio, hazardcount}}
--   end,

--   calculate = function(self, card, context)
--     if context.setting_blind then
--       poke_add_hazards(self.config.extra.hazard_ratio)
--     end
--   end
-- } 
if sonfive_config.customItems then
local dList = {reverencedeck, virtuousdeck, propheticdeck, shinydeck, megadeck, voiddeck}
return {name = "Back",
        list = dList
        
}
else 
  local dList = {reverencedeck, propheticdeck, shinydeck, megadeck, voiddeck}


return {name = "Back",
        list = dList
        
}
end

