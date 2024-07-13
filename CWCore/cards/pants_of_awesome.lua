-- Status: not tested

function _Create()
    local result = CardWars:Spell()

    CW.AddRestriction(result,
        function (id, playerI)
            return nil,
                #CW.Targetable.BySpell(Common.Creatures(playerI), playerI, id) > 0 and
                #Common.LandscapesWithoutCreaturesTyped(playerI, CardWars.Landscapes.BluePlains) > 0
        end
    )

    result.EffectP:AddLayer(
        function (id, playerI)
            -- Move target Creature you control to an empty Blue Plains Landscape you control, and then draw a card.
            local ipids = CW.IPIDs(CW.Targetable.BySpell(Common.Creatures(playerI), playerI, id))
            local target = TargetCreature(playerI, ipids, 'Choose a creature to move')

            local empty = CW.Lanes(Common.LandscapesWithoutCreaturesTyped(playerI, CardWars.Landscapes.BluePlains))
            local lane = ChooseLane(playerI, empty, 'Choose an empty Lane to move to')

            MoveCreature(target, lane)

            Draw(playerI, 1)
        end
    )

    return result
end