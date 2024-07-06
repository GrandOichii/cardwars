-- Status: implemented

function _Create()
    local result = CardWars:Creature()

    result:AddActivatedAbility({
        text = 'FLOOP >>> Move a Creature you control to an empty Lane.',
        tags = {'floop'},

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
        effectF = function (me, playerI, laneI)
            local creatures = Common.IDs(Common.Creatures(playerI))
            local creatureId = ChooseCreature(playerI, creatures, 'Choose a creature to move')

            local options = Common.Lanes(Common.LandscapesWithoutCreatures(playerI))
            local lane = ChooseLane(playerI, options, 'Choose an empty Lane to move to')

            MoveCreature(creatureId, lane)
        end
    })

    return result
end