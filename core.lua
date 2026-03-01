local chance_display_keys = {
    "Percent",
    "Odds"
}

Bloodstoned = {
    base = SMODS.current_mod,
    id = SMODS.current_mod.id,
    config = SMODS.current_mod.config
}

mod = Bloodstoned

mod.SMODS_VERSION = "1.0.0"

SMODS.Atlas({
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34,
})


local items = NFS.getDirectoryItems(SMODS.current_mod.path .. "items")
for _, file in ipairs(items) do
	assert(SMODS.load_file("items/" .. file))()
    print("[Bloodstoned] Loading file: items/" .. file)

end

function Card:createProcUI(card, hits, checks)
    local percent = checks > 0 and (hits / checks) or -1

    percent = math.floor(percent * 100)

    local colour
    if percent > 50 then
        colour = G.C.GREEN
    elseif percent == 50 then
        colour = G.C.MONEY
    else
        colour = G.C.RED
    end

    local percent_display = percent .. "%"
    local odds_display = tostring(hits) .. "/" .. tostring(checks)

    local modes = {"percent", "odds"}
    local mode = modes[mod.config.chance_display_id or 1]

    local display = "x%"

    print("MODE: " .. mode)

    if mode == "percent" then
        display = percent_display
    end

    if mode == "odds" then
        display = odds_display
    end

    if percent == -100 then
        return
    end

	if card.children.proc_ui then
		card.children.proc_ui:remove()
		card.children.proc_ui = nil
	end
    if not card.children.proc_ui and card.config.center_key == "j_bloodstone" then
        card.children.proc_ui = UIBox({
            definition = {
                n = G.UIT.ROOT,
                config = {
                    align = "cm",
                    colour = G.C.CLEAR,
                    shadow = true,
                    ref_table = card,
                },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            minh = 0.32,
                            minw = 0.55,
                            padding = 0.08,
                            r = 0.03,
                            colour = HEX("22222266"),
                        },
                        nodes = {
                            {
                                n = G.UIT.O,
                                config = {
                                    object = DynaText({
										string = { tostring(display)},
                                        colours = { colour },
                                        shadow = true,
                                        silent = true,
                                        bump = true,
                                        pop_in = 0.15,
                                        scale = 0.42,
                                    }),
                                },
                            },
                        },
                    },
                },
            },
            config = {
                align = "cm",
                parent = card,
                offset = {
                    x = -0.7,
                    y = -1.2,
                },
            },
            states = {
                collide = { can = false },
                drag = { can = false },
            },
        })
    end
end

function mod.reset_game_globals(reset)
    G.GAME.bloodstoned = G.GAME.bloodstoned or {}
end

function G.FUNCS.change_chance_display(args)
    mod.config.chance_display_id = args.to_key
    SMODS.save_mod_config(mod.base)
end

mod.base.config_tab = function()
    print(mod.config)
    return {
		n = G.UIT.ROOT,
		config = { r = 0.1, minw = 4, align = "tm", padding = 0.2, colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.C,
				config = { r = 0.1, minw = 4, align = "tc", padding = 0.2, colour = G.C.BLACK },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", r = 0.1, padding = 0.2 },
						nodes = {
                            create_option_cycle({
                            label = "Chance Display",
                            scale = 0.8,
                            w = 4,
                            options = chance_display_keys,
                            opt_callback = "change_chance_display",
                            current_option = mod.config.chance_display_id or 1,
                            }),
						}
					},
				}
			}
		}
	}
end