-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Pay 1 Action >>> Target Creature in this Lane has -10 ATK this turn.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.PayActionPoints(1),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():InLane(laneI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to debuff'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local ipid = targets.creature.Original.IPID

            UntilEndOfTurn(function (layer)
                if layer == CardWars.ModificationLayers.ATK_AND_DEF then
                    local creature = GetCreatureOrDefault(ipid)
                    if creature == nil then
                        return
                    end
                    creature.Attack = creature.Attack - 10
                    if creature.Attack < 0 then
                        creature.Attack = 0
                    end
                end
            end)
        end
    )

    return result
end