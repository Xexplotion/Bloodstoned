local calc_ref = Card.calculate_joker

function Card:calculate_joker(context)
    local result = calc_ref(self, context)

    G.GAME.bloodstoned = G.GAME.bloodstoned or {}
    G.GAME.bloodstoned.bloodstone_stats = G.GAME.bloodstoned.bloodstone_stats or {}

    local id = self.unique_val
    local stats = G.GAME.bloodstoned.bloodstone_stats[id] or { total_checks = 0, total_hits = 0 }
    G.GAME.bloodstoned.bloodstone_stats[id] = stats

    if context.individual and context.cardarea == G.play then
        if self.config.center_key == "j_bloodstone" then
            if context.other_card then
                if context.other_card:is_suit("Hearts") then
                    stats.total_checks = stats.total_checks + 1
                end
            end

            if result and result.x_mult then
                stats.total_hits = stats.total_hits + 1
            end
        end
    end

    if context.after and self.config.center_key == "j_bloodstone" and not context.blueprint then
        return {
            func = function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local checks = stats.total_checks or 0
                        local hits = stats.total_hits or 0
                        local percent = checks > 0 and (hits / checks) or -1

                        self:createProcUI(self, math.floor(percent * 100))

                        stats.total_hits = 0
                        stats.total_checks = 0

                        return true
                    end
                }))
            end
        }
    end

    return result
end