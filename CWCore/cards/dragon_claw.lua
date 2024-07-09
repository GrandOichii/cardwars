-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    local creatureFilter = function (playerI, laneI)
        return CW.CreatureFilter():ControlledBy(playerI)
    end

    local landscapeFilter = function (playerI, laneI)
        return CW.LandscapeFilter():OwnedBy(playerI):Empty()
    end

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Move a Creature you control to an empty Lane.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #creatureFilter(playerI, laneI):Do() > 0
            end),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #landscapeFilter(playerI, laneI):Do() > 0
            end)
        ),
        function (me, playerI, laneI)
            local creature = CW.Choose.Creature(playerI, creatureFilter(playerI, laneI):Do(), 'Choose a creature to move')
            assert(creature ~= nil, 'failed to target creature in card '..me.Original.Card.Template.Name)

            local landscape = CW.Choose.Lane(playerI, landscapeFilter(playerI, laneI):Do(), 'Choose an empty Landscape to move '..creature.Original.Card.Template.Name..' to')
            assert(landscape ~= nil, 'failed to target landscapes in card '..me.Original.Card.Template.Name)

            MoveCreature(creature.Original.Card.ID, landscape.Original.Idx)
        end
    )

    return result
end