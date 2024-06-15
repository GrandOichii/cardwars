-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.Floop(result,
        'FLOOP >>> Heal 1 Damage from Corns Templar.',
        function (me, playerI, laneI)
            HealDamage(STATE.Players[playerI].Landscapes[laneI].Creature.Original.Card.ID, 1)
        end
    )

    return result
end