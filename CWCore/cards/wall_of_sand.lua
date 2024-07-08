-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    -- If one or more other SandyLand Creatures enter play during you turn, Wall of Sand has +2 ATK this turn.
    CW.State.ModATKDEF(result, function (me)
        -- TODO? the "enter play during your turn" kinda scares me
        local id = me.Original.Card.ID
        for i = 0, 1 do
            local p = STATE.Players[i]
            for ii = 0, p.Landscapes.Count - 1 do
                local creatures = p.Landscapes[ii].Original.CreaturesEnteredThisTurn
                for ci = 0, creatures.Count - 1 do
                    local creature = creatures[ci]
                    if creature.ID ~= id and creature.Template.Landscape == CardWars.Landscapes.SandyLands then
                        me.Attack = me.Attack + 2
                        return
                    end
                end
            end
        end
    end)

    return result
end