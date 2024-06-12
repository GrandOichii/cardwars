-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        function (me, playerI, laneI)
            HealDamage(STATE.Players[playerI].Landscapes[laneI].Creature.Original.Card.ID, 1)
        end
    )

    return result
end