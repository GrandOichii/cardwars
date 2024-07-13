-- Status: implemented, requires some more testing

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Travelin\' Skeleton and another Creature you control change Lanes with each other.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Creature(
                'creature',
                function (me, playerI, laneI)
                    return CW.CreatureFilter()
                        :ControlledBy(playerI)
                        :Except(me.Original.IPID)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Creature to change Lanes with '..me.Original.Card.Template.Name
                end
            )
        ),
        function (me, playerI, laneI, targets)
            SwapCreatures(me.Original.IPID, targets.creature.Original.IPID)
        end
    )

    return result
end