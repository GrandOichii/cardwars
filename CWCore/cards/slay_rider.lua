-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Deal 3 Damage to target Creature on a Landscape with a Frozen token on it.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():OnFrozenLandscapes()
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a frozen Creature'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, targets.creature.Original.IPID, 3)
        end,
        -1
    )

    return result
end