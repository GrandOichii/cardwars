-- Status: implemented

function _Create(props)
    local result = CardWars:Creature(props)

    -- FLOOP >>> Draw a card for each Flooped Creature you control (including this one).
    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            local ownerI = me.Original.OwnerI
            local creatures = Common.FloopedCreatures(playerI)
            Draw(playerI, #creatures)
        end
    )

    return result
end