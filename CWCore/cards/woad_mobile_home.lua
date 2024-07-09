-- Status: not tested

function _Create()
    local result = CardWars:InPlay()

    local filter = function (playerI, laneI)
        return CW.CreatureFilter():AdjacentToLane(laneI):ControlledBy(playerI)
    end

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Move a Creature in an adjacent Lane to this Lane (if empty).',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return CW.Landscape.IsEmpty(playerI, laneI)
            end),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #filter(playerI, laneI):Do() > 0
            end)
        ),
        function (me, playerI, laneI)
            local creature = CW.Choose.Creature(playerI, filter(playerI, laneI):Do())
            assert(creature ~= nil, 'TODO write this error message later')

            -- TODO change to IPID
            MoveCreature(creature.Original.Card.ID, laneI)
        end
    )

    return result
end