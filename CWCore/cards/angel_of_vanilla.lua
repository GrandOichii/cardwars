-- Status: not tested

function _Create(props)
    local result = CardWars:Creature(props)

    Common.ActivatedEffects.PayActionPoints(result, 1,
        'Pay 1 Action >>> Heal all Damage from Angel of Vanilla.',
        function (me, playerI, laneI)
            HealDamage(me.Original.Card.ID, me.Original.Damage)
        end
    )

    return result
end