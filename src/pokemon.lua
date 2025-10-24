local subdir = "src/pokemon/"

local function load_pokemon_folder(folder)
  local pfiles = NFS.getDirectoryItems(mod_dir..folder)
  if (SMODS.Mods["Pokermon"] or {}).can_load and SMODS.Mods["Pokermon"] and sonfive_config.customJokers then
    for _, file in ipairs(pfiles) do
      sendDebugMessage("The file is: " .. file)
      local pokemon, load_error = SMODS.load_file(folder .. file)
      if load_error then
        sendDebugMessage("The error is: " .. load_error)
      else
        local curr_pokemon = pokemon()
        if curr_pokemon.init then curr_pokemon:init() end

        local family = {}

        if curr_pokemon.list and #curr_pokemon.list > 0 then
          for _, item in ipairs(curr_pokemon.list) do
            family[#family + 1] = item.name

            if (pokermon_config.jokers_only and not item.joblacklist) or not pokermon_config.jokers_only then
              item.discovered = true
              if not item.key then item.key = item.name end

              if not pokermon_config.no_evos and not item.custom_pool_func then
                item.custom_pool_func = true
                item.in_pool = function(self)
                  local base_evo_name = sonfive_base_evo_name(self)
                  if (sonfive_config[base_evo_name]) then
                    return pokemon_in_pool(self)
                  end
                  return false
                end
              end

              if not item.config then item.config = {} end

              if not item.pos then
                local sprite = PokemonSprites[item.name]
                if sprite and sprite.base then
                  item.pos = sprite.base.pos
                  if sprite.base.soul_pos then
                    item.soul_pos = sprite.base.soul_pos
                  end
                end
              end

              if not item.atlas then
                local sprite = PokemonSprites[item.name]
                local gen_string = nil
                local atlas_prefix = item.custom_art and "AtlasJokersSeriesA" or "AtlasJokersBasic"
                if sprite.gen_atlas and item.gen then
                  if item.gen < 10 then
                    gen_string = 'Gen0' .. item.gen
                  else
                    gen_string = 'Gen' .. item.gen
                  end
                  item.atlas = atlas_prefix .. gen_string
                else
                  item.atlas = atlas_prefix .. "Natdex"
                end
              end

              if item.ptype then
                item.config.extra = item.config.extra or {}
                item.config.extra.ptype = item.ptype
              end
              if not item.set_badges then item.set_badges = poke_set_type_badge end

              if item.item_req then
                item.config.extra = item.config.extra or {}
                item.config.extra.item_req = item.item_req
              end
              if item.evo_list then
                item.config.extra = item.config.extra or {}
                item.config.extra.evo_list = item.evo_list
              end
              if pokermon_config.jokers_only and item.rarity == "poke_safari" then
                item.rarity = 3
              end

              item.discovered = not pokermon_config.pokemon_discovery
              pokermon.Pokemon(item, "sonfive", nil)
            end
          end

          -- 🔥 Automatically register this family
          if #family > 1 then
            pokermon.add_family(family)
          end
        end
      end
    end
  end
end

load_pokemon_folder(subdir)
