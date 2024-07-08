-- Status: implemented

function _Create()
    local result = CardWars:Spell()

    -- TODO? does this spell target
    Common.AddRestriction(result,
        function (id, playerI)
            return nil,
                #Common.Creatures(playerI) > 0 and
                #Common.LandscapesWithoutCreatures(playerI) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Move one of your Creatures to one of your empty Lanes.

            local creatures = CW.IDs(Common.Creatures(playerI))
            local empty = CW.Lanes(Common.LandscapesWithoutCreatures(playerI))

            local creatureId = ChooseCreature(playerI, creatures, 'Choose a creature to move')
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')
            MoveCreature(creatureId, lane)
        end
    )

    return result
end