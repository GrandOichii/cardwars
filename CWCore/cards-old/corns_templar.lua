-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.Floop(result,
        'FLOOP >>> Heal 1 Damage from Corns Templar.',
        function (me, playerI, laneI)
            HealDamage(STATE.Players[playerI].Landscapes[laneI].Creature.Original.Card.ID, 1)
        end
    )

    return result
end