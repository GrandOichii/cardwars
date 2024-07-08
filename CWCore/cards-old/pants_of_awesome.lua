-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    Common.AddRestriction(result,
        function (playerI)
            return nil,
                #Common.Targetable(playerI, Common.Creatures(playerI)) > 0 and
                #Common.LandscapesWithoutCreaturesTyped(playerI, CardWars.Landscapes.BluePlains) > 0
        end
    )

    result.EffectP:AddLayer(
        function (playerI)
            -- Move target Creature you control to an empty Blue Plains Landscape you control, and then draw a card.
            local ids = CW.IDs(Common.Targetable(playerI, Common.Creatures(playerI)))
            local target = TargetCreature(playerI, ids, 'Choose a creature to move')

            local empty = Common.Lanes(Common.LandscapesWithoutCreaturesTyped(playerI, CardWars.Landscapes.BluePlains))
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            MoveCreature(target, lane)

            Draw(playerI, 1)
        end
    )

    return result
end