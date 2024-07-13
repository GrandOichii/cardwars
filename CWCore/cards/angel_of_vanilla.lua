-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Common.PayActionPoints(
        result,
        'Pay 1 Action >>> Heal all Damage from Angel of Vanilla.',
        1,
        function (me, playerI, laneI)
            HealDamage(me.Original.IPID, me.Original.Damage)
        end
    )

    return result
end