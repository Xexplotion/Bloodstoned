mod = SMODS.current_mod

mod.SMODS_VERSION = "1.0.0"

Bloodstoned = {}

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

function Card:createProcUI(card, procs)
    local colour
    if procs > 50 then
        colour = G.C.GREEN
    elseif procs == 50 then
        colour = G.C.MONEY
    else
        colour = G.C.RED
    end

	if card.children.proc_ui then
		card.children.proc_ui:remove()
		card.children.proc_ui = nil
	end
    if not card.children.proc_ui and procs ~= -1 * 100 and card.config.center_key == "j_bloodstone" then
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
										string = { tostring(procs) .. "%"},
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