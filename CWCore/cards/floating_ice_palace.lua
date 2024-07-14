-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    -- Your Creature on this Landscape has +1 ATK during your turn for each Landscape with a Frozen token on it.
    CW.State.ModATKDEF(result, function (me)
        local creatures = CW.CreatureFilter()
            :ControlledBy(me.Original.ControllerI)
            :InLane(me.LaneI)
            :Do()

        if #creatures == 0 then
            return
        end
        local creature = creatures[1]
        local landscapes = CW.LandscapeFilter():IsFrozen():Do()
        creature.Attack = creature.Attack + #landscapes
    end)

    return result
end