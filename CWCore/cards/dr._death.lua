-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'Destroy a Creature you control and FLOOP >>> Destroy target opposing Creature in this Lane.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.SacrificeACreature(
                function (me, playerI, laneI)
                    return CW.CreatureFilter():Except(me.Original.IPID)
                end,
                'Choose a creature to sacrifice to Dr. Death'
            ),
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter():InLane(laneI):OpposingTo(playerI):Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to Destroy'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            DestroyCreature(targets.creature.Original.IPID)
        end
    )

    return result
end