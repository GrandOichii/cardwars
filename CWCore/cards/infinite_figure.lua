-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Discard a card >>> Deal 1 Damage to another Creature in this Lane. (Use any number of times during each of your turns.)',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.DiscardFromHand(1),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter()
                        :InLane(laneI)
                        :Except(me.Original.IPID)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to deal 1 Damage to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            CW.Damage.ToCreatureByCreatureAbility(me.Original.IPID, playerI, targets.creature.Original.IPID, 1)
        end
    )

    return result
end