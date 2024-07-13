-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Pay 1 Action >>> Move all Damage on this Creature to target Creature.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.PayActionPoints(1),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter()
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to move '..me.Original.Damage..' Damage to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local creature = targets.creature
            local damage = me.Original.Damage
            me.Original.Damage = 0
            creature.Original.Damage = damage
        end,
        -1
    )

    return result
end