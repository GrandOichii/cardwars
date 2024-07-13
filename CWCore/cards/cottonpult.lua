-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Deal 1 Damage to target Creature. If Cottonpult has 5 or more Damage on it, it heals 1 Damage and readies.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    -- * not specified in the rules, but during testing this leads to an infinite loop
                    return CW.CreatureFilter():Except(me.Original.IPID)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to deal Damage to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local myIPID = me.Original.IPID
            CW.Damage.ToCreatureByCreatureAbility(myIPID, playerI, targets.creature.Original.IPID, 1)
            if me.Original.Damage >= 5 then
                HealDamage(myIPID, 1)
                ReadyCard(myIPID)
            end
        end,
        -1
    )

    return result
end