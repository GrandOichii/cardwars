-- Status: partially implemented

function _Create(props)
    local result = CardWars:Spell(props)

    -- !FIXME add check function - check that a creature exists and can be moved

    -- TODO repeated code

    result.EffectP:AddLayer(
        function (playerI)
            -- Move one of your Creatures to one of your empty Lanes.

            -- !FIXME remove
            local creatures = Common:IDs(Common:Creatures(playerI))
            if #creatures == 0 then
                return
            end
            local empty = Common:LandscapesWithoutCreatures(playerI)
            if #empty == 0 then
                return
            end

            local creatureId = ChooseCreature(playerI, creatures, 'Choose a creature to move')
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')
            MoveCreature(creatureId, lane)
        end
    )

    return result
end