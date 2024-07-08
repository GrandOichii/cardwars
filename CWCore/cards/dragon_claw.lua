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
            assert(creature ~= nil, 'TODO write error')
            local landscape = CW.Choose.Landscape(playerI, landscapeFilter(playerI, laneI):Do(), 'Choose an empty Landscape to move '..creature.Original.Card.Template.Name..' to')
            local options = CW.Lanes(Common.LandscapesWithoutCreatures(playerI))
            local lane = ChooseLane(playerI, options, 'Choose an empty Lane to move to')

            MoveCreature(creatureId, lane)
        end
    )

    result:AddActivatedAbility({
        checkF = function (me, playerI, laneI)
            if not Common.CanFloop(me) then
                return false
            end
            return #Common.LandscapesWithoutCreatures(playerI) > 0
        end,
        costF = function (me, playerI, laneI)
            FloopCard(me.Original.Card.ID)
            return true
        end,
        effectF = 
    })

    return result
end