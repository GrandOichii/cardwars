-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Move Boarder Collie to any of your empty Landscapes. If either Landscape in that Lane is Frozen, gain 1 Action.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Target.Landscape(
                'landscape',
                function (me, playerI, laneI)
                    return CW.LandscapeFilter():Empty():ControlledBy(playerI)
                        :Do()
                end,
                function (me, playerI, laneI, targets)
                    return 'Choose a Landscape to move '..me.Original.Card.Template.Name..' to'
                end
            )
        ),
        function (me, playerI, laneI, targets)
            local laneIdx = targets.landscape.Original.Idx
            MoveCreature(me.Original.IPID, laneIdx)

            if #CW.LandscapeFilter():OnLane(laneIdx):IsFrozen():Do() == 0 then
                return
            end

            AddActionPoints(playerI, 1)
        end
    )

    return result
end