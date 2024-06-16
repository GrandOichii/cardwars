-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    Common.ActivatedAbilities.PayActionPoints(result, 1,
        'Pay 1 Action >>> Heal all Damage from Angel of Chocolate.',
        function (me, playerI, laneI)
            HealDamage(me.Original.Card.ID, me.Original.Damage)
        end
    )

    return result
end