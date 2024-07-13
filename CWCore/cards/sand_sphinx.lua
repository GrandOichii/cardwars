-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Return a Creature you control in this Lane to its owner\'s hand.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():InLane(laneI):ControlledBy(playerI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to return to hand'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            ReturnCreatureToOwnersHand(targets.creature.Original.IPID)
        end
    )

    return result
end