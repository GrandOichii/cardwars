-- Your Creature in this Lane has +1 DEF for every 5 cards in your discard pile.
-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.State.ModATKDEF(result, function (me)
        local player = STATE.Players[me.Original.ControllerI]
        local creature = player.Landscapes[me.LaneI].Creature
        if creature == nil then
            return
        end
        local count = player.DiscardPile.Count
        if count == 0 then
            return
        end
        creature.Defense = creature.Defense + math.floor(count / 5)
    end)

    return result
end