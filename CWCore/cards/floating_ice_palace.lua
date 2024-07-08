-- Status: not tested

function _Create()
    local result = CardWars:InPlay()
    
    -- Your Creature on this Landscape has +1 ATK during your turn for each Landscape with a Frozen token on it.
    CW.State.ModATKDEF(result, function (me)
        local creatures = Common.CreaturesInLane(me.Original.ControllerI, me.LaneI)
        if #creatures == 0 then
            return
        end
        local creature = creatures[1]
        local landscapes = Common.AllPlayers.FrozenLandscapes()
        local amount = #landscapes
        creature.Attack = creature.Attack + amount
    end)

    return result
end