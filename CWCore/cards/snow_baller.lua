-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Remove a Frozen token from Snow Baller\'s Landscape >>> Deal 3 Damage to target Creature.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return CW.LandscapeOf(me):IsFrozen()
            end),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter()
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to deal 3 Damage to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            RemoveToken(playerI, laneI, 'Frozen')
            CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, targets.creature.Original.IPID, 3)
        end,
        -1
    )

    return result
end