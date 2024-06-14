-- Status: implemented

function _Create(props)
    local result = CardWars:Spell(props)

    Common.AddRestriction(result, function (playerI)
        return nil,
            #Common.Creatures(playerI) > 0 and
            #Common.LandscapesWithoutCreatures(playerI) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Move one of your Creatures to one of your empty Lanes.

            local creatures = Common.IDs(Common.Creatures(playerI))
            local empty = Common.Lanes(Common.LandscapesWithoutCreatures(playerI))

            local creatureId = ChooseCreature(playerI, creatures, 'Choose a creature to move')
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')
            MoveCreature(creatureId, lane)
        end
    )

    return result
end